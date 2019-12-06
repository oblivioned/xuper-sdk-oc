//
//  XTransactionBuilder.m
//  xuper-sdk-oc-iOS
//
//  Created by apple on 2019/12/6.
//  Copyright © 2019 Martin.Ren. All rights reserved.
//

#import "Xchain.pbobjc.h"

#import "XTransactionBuilder.h"
#import "XTransactionDesc.h"
#import "XTransactionOpt.h"
#import "XCryptoKeypairProtocol.h"
#import "Transaction+SDKExtension.h"
#import "GPBMessage+RandomHeader.h"
#import "XCryptoFactory.h"

@implementation XTransactionBuilder

+ (int64_t) timestamp18 {
    
    NSTimeInterval t = [[NSDate date] timeIntervalSince1970];
    
    return (int64_t)(t * 100000000L);
}

/// 生产一个随机的18位Nonce
+ (NSString *) randomNonce {
    return [NSString stringWithFormat:@"%lld", self.timestamp18];
}

+ (void) buildTrsanctionWithClient:(id<XClient> _Nonnull)client
                            option:(XTransactionOpt * _Nonnull)opt
                     initorKeypair:(id<XCryptoKeypairProtocol> _Nonnull)initorKeypair
               authRequireKeypairs:(NSArray<id<XCryptoKeypairProtocol>> *_Nullable)authRequireKeypairs
                            handle:(XTransactionBuilderResponse _Nonnull)handleBlock {
    
    __block Transaction *tx = [Transaction message];
        
    ///--txversion int32      tx version (default 1)
    tx.version = 1;
    tx.coinbase = false;
    
    //TODO
    tx.desc = opt.desc.encodeToData;
    tx.nonce = self.randomNonce;
    
    /// 18 位时间戳
    tx.timestamp = self.timestamp18;
    tx.initiator = opt.from;

    XBigInt *totalNeed = XBigInt.Zero;
    
    /// txoutputs 转出给其他地址的
    for ( XTranctionToAccountData *toAccountData in opt.to ) {
        
        [totalNeed addBigInt:toAccountData.amount];
        
        TxDataAccount *to = [TxDataAccount message];
        to.address = toAccountData.address;
        to.amount = toAccountData.amount.decString;
        to.frozenHeight = toAccountData.frozenHeight;
            
        ///组装output
        TxOutput *output = [TxOutput message];

        /// totalNeed 和 amount 是要分开的，自处因为数值相同，就直接只用同一个对象
        output.toAddr = [to.address dataUsingEncoding:NSUTF8StringEncoding];
        output.amount =  toAccountData.amount.data;
        output.frozenHeight = to.frozenHeight;
        
        [tx.txOutputsArray addObject:output];
    }

    // 组装input 和 剩余output
    UtxoInput *ui = [UtxoInput message];
    ui.header = UtxoInput.getRandomHeader;
    ui.bcname = opt.globalFlags.blockchainName;
    ui.address = opt.from;
    ui.totalNeed = totalNeed.decString;
    
    /*
     Q:pb.UtxoInput 中 needLock 设置为 true 或者 false 在调用GRPC接口selectUTXOWithRequest 的时候会有何区别什么场景时应该使用true，什么场景的时候应该使用false ？
     A:needLock为true的话，意思是SelectUtxos获取到的utxo在短时间内（这个时间可以在配置文件中配置）会被锁定，其他人无法使用。
     
     Q:那么对于类似HTML ios 安卓这样的前端来说，因为私钥都在本地，他不是一个大家共用的东西，也不会一个私钥好几个人都知道，那么设置needLock = false应该会合理一些吧，比如进行了selectUtxos后，凑巧网络出现问题（基站切换啊，欠费啊，闪退啊导致后续的交易没有成功），如果 needlock=true的话，会导致重启以后一段时间内 不能再次选择这些交易，所以在前端上 设置为false 更加合理 ？ 您看对吗？
     A:对，合理
     
     So:所以needlock在sdk中设置为false
     */
    ui.needLock = false;

    [client selectUTXOWithRequest:ui handler:^(UtxoOutput * _Nullable response, NSError * _Nullable error) {
        
        if ( error != nil ) {
            return handleBlock(nil, error);
        }
        
        if ( response.header.error != XChainErrorEnum_Success ) {
            return handleBlock(nil, [NSError errorWithDomain:@"selectUTXOWithRequest response a error." code:response.header.error userInfo:nil]);
        }
        
        if ( !response ) {
            return handleBlock(nil, [NSError errorWithDomain:@"selectUTXOWithRequest no error, but response is invaild." code:response.header.error userInfo:nil]);
        }
        
        UtxoOutput *utxoRes = response;
        
        /// 类似BTC的找零机制
        /// txinputs
        NSMutableArray<TxInput*> *txTxInputs = [[NSMutableArray alloc] init];
        
        for ( Utxo *utxo in utxoRes.utxoListArray ) {
            TxInput *txinputIt = [TxInput message];
            txinputIt.refTxid = utxo.refTxid;
            txinputIt.refOffset = utxo.refOffset;
            txinputIt.fromAddr = utxo.toAddr;
            txinputIt.amount = utxo.amount;
            [txTxInputs addObject:txinputIt];
        }
        tx.txInputsArray = txTxInputs;
        
        XBigInt *totalSelected = [[XBigInt alloc] initWithDecString:utxoRes.totalSelected];

        /// 多出来的utxo需要再转给自己
        /// txoutpus
        if ( [totalSelected greaterThan:totalNeed] ) {
            
            TxOutput *delta_output = [TxOutput message];
            
            XBigInt *delta = [totalSelected bigIntBySubBigInt:totalNeed];
            
            delta_output.toAddr = [opt.from dataUsingEncoding:NSUTF8StringEncoding];
            delta_output.amount = delta.data;
            
            [tx.txOutputsArray addObject:delta_output];
        }
       
        /// 设置auth require
        [tx.authRequireArray addObjectsFromArray:opt.desc.authRequires];
    
        /// 进行一个预发送流程，不真正执行交易,但是需要填充一些参数主要是 contractRequestsArray,txInputsExtArray,txOutputsExtArray
        InvokeRPCRequest *preExeRPCReq = [InvokeRPCRequest message];
        preExeRPCReq.header = InvokeRPCRequest.getRandomHeader;
        preExeRPCReq.bcname = opt.globalFlags.blockchainName;
        preExeRPCReq.initiator = opt.from;
        preExeRPCReq.authRequireArray = tx.authRequireArray;

        [client preExecWithRequest:preExeRPCReq handler:^(InvokeRPCResponse * _Nullable response, NSError * _Nullable error) {
            
            if ( error != nil ) {
                return handleBlock(nil, error);
            }
            
            if ( response.header.error != XChainErrorEnum_Success ) {
                return handleBlock(nil, [NSError errorWithDomain:@"preExecWithRequest response a error." code:response.header.error userInfo:nil]);
            }
            
            if ( !response ) {
                return handleBlock(nil, [NSError errorWithDomain:@"preExecWithRequest no error, but response is invaild." code:response.header.error userInfo:nil]);
            }
            
            InvokeRPCResponse * preExeRes = response;
            
            tx.contractRequestsArray = preExeRes.response.requestsArray;
            tx.txInputsExtArray = preExeRes.response.inputsArray;
            tx.txOutputsExtArray = preExeRes.response.outputsArray;
            
            
            /// 签名和生成txid
            NSError *signError;
            id<XCryptoClientProtocol> cryptoClient = [XCryptoFactory cryptoClientWithCryptoType:opt.globalFlags.cryptoType];
            if (signError) {
                return handleBlock(nil, signError);
            }
            
            /// initor sign
            SignatureInfo *initorSig = [tx txProcessSignInfoWithClient:cryptoClient keypair:initorKeypair error:&signError];
            [tx.initiatorSignsArray addObject:initorSig];
            
            /// authRequire签名
            for ( id<XCryptoKeypairProtocol> aclKeypari in authRequireKeypairs ) {
                
                SignatureInfo *aclSign = [tx txProcessSignInfoWithClient:cryptoClient keypair:aclKeypari error:&signError];
                if (signError) {
                    return handleBlock(nil, signError);
                }
                
                [tx.authRequireSignsArray addObject:aclSign];
            }
            
            tx.txid = tx.txMakeTransactionID;
            
            return handleBlock(tx, nil);
            
        }];

    }];
    
    return ;
//        TxStatus *tx_status = [TxStatus message];
//        tx_status.header = TxStatus.getRandomHeader;
//        tx_status.bcname = @"xuper";
//        tx_status.status = TransactionStatus_Unconfirm;
//        tx_status.tx = tx;
//        tx_status.txid = tx_status.tx.txid;
        
//        XCTestExpectation *expectationPostTx = [self expectationWithDescription:@"PostTxWithRequest"];
//        [self.client postTxWithRequest:tx_status handler:^(CommonReply * _Nullable response, NSError * _Nullable error) {
//            XCTAssertNil(error);
//            XCTAssertNotNil(response);
//            XCTAssert(response.header.error != XChainErrorEnum_TxVerificationError);
//            [expectationPostTx fulfill];
//        }];
//        [self waitForExpectations:@[expectationPostTx] timeout:5];
//
//
//        TxStatus *txQueryMessage = [TxStatus message];
//        txQueryMessage.header = TxStatus.getRandomHeader;
//        txQueryMessage.txid = tx_status.txid;
//        txQueryMessage.bcname = @"xuper";
//        [self.client queryTxWithRequest:txQueryMessage handler:^(TxStatus * _Nullable response, NSError * _Nullable error) {
//            printf("QueryTxResponse:\n");
//            printf("%s\n", response.tx.description.UTF8String);
//            AsyncTestFulfill();
//        }];
}


@end
