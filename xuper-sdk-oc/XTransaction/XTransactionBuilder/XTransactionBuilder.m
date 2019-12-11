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
#import "XTransactionDescInvoke.h"

@implementation XTransactionBuilder

+ (int64_t) timestamp18 {
    
    NSTimeInterval t = [[NSDate date] timeIntervalSince1970];
    
    return (int64_t)(t * 100000000L);
}

/// 生产一个随机的18位Nonce
+ (NSString *) randomNonce {
    return [NSString stringWithFormat:@"%lld", self.timestamp18];
}

/// 生成交易，不包含签名
/// \param client XClient实现类,用于GRPC通讯
/// \param opt 事务描述对象，为XTransactionOpt的派生类
/// \param handleBlock 返回结果或者异常的block
+ (void) buildTrsanctionWithClient:(id<XClient> _Nonnull)client
                            option:(XTransactionOpt * _Nonnull)opt
                            handle:(XTransactionBuilderResponse _Nonnull)handleBlock {
    
    return [self trsanctionWithClient:client option:opt ignoreFeeCheck:NO initorKeypair:nil authRequireKeypairs:nil handle:handleBlock];
}

+ (void) buildPreExecTransactionWithClient:(id<XClient> _Nonnull)client
                                    option:(XTransactionOpt * _Nonnull)opt
                                    handle:(XTransactionBuilderResponse _Nonnull)handleBlock {
    
    return [self trsanctionWithClient:client option:opt ignoreFeeCheck:YES initorKeypair:nil authRequireKeypairs:nil handle:handleBlock];
    
}

+ (void) trsanctionWithClient:(id<XClient> _Nonnull)client
                       option:(XTransactionOpt * _Nonnull)opt
               ignoreFeeCheck:(BOOL)ignoreFeeCheck
                initorKeypair:(id<XCryptoKeypairProtocol> _Nullable)initorKeypair
          authRequireKeypairs:(NSArray<id<XCryptoKeypairProtocol>> *_Nullable)authRequireKeypairs
                       handle:(XTransactionBuilderResponse _Nonnull)handleBlock {
    
    __block Transaction *tx = [Transaction message];
        
    /// --txversion int32      tx version (default 1)
    tx.version = 1;
    tx.coinbase = false;
    
    tx.desc = opt.desc.encodeToData;
    tx.nonce = self.randomNonce;
    
    /// 18 位时间戳
    tx.timestamp = self.timestamp18;
    tx.initiator = opt.from;

    XBigInt *totalNeed = XBigInt.Zero;
    
    /// txoutputs -- 手续费部分
    if ( opt.fee && [opt.fee greaterThan:XBigInt.Zero] ) {
        
        /// 配置了手续费，增加一笔outputs
        [totalNeed addBigInt:opt.fee];
        
        /// 手续费的Output
        TxOutput *output = [TxOutput message];
        
        /// 手续费的固定账号
        output.toAddr = [@"$" dataUsingEncoding:NSUTF8StringEncoding];
        output.amount =  opt.fee.data;
        
        [tx.txOutputsArray addObject:output];
    }
    
    /// txoutputs 转出给其他地址的
    for ( XTranctionToAccountData *toAccountData in opt.to ) {
        
        [totalNeed addBigInt:toAccountData.amount];
        
        ///组装output
        TxOutput *output = [TxOutput message];
        output.toAddr = [toAccountData.address dataUsingEncoding:NSUTF8StringEncoding];
        output.amount =  toAccountData.amount.data;
        output.frozenHeight = toAccountData.frozenHeight;
        
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
    
        /// 进行一个预发送流程，不真正执行交易,但是需要填充一些参数主要是 contractRequestsArray,txInputsExtArray,txOutputsExtArray,手续费等
        InvokeRPCRequest *preExeRPCReq = [InvokeRPCRequest message];
        preExeRPCReq.header = InvokeRPCRequest.getRandomHeader;
        preExeRPCReq.bcname = opt.globalFlags.blockchainName;
        preExeRPCReq.initiator = opt.from;
        preExeRPCReq.authRequireArray = tx.authRequireArray;
        
        /// InvokeRPCRequest中记录了合约交互的API和参数,而这些执行需要根据desc来判断
        if ( [opt.desc isKindOfClass:[XTransactionDescInvoke class]] ) {
            [preExeRPCReq.requestsArray addObject:((XTransactionDescInvoke*)opt.desc).invokeRequest];
        }
        
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
            
            /// 累加手续费
            XBigInt *totalGasPrice = XBigInt.Zero;
            
            if ( preExeRes.response.gasUsed > 0) {
                    
                NSString *lldNumberString = [NSString stringWithFormat:@"%lld", preExeRes.response.gasUsed];
                    
                [totalGasPrice addBigIntDec:lldNumberString];
            }
            
            /// 当交易需要使用手续费时，但配置的手续不足以支付或根本没有配置支付的金额时跳出
            if (
                !ignoreFeeCheck && /// 跳过手续费强制检测流程
                ([totalGasPrice greaterThan:XBigInt.Zero] &&
                (!opt.fee || [opt.fee lessThan:totalGasPrice] ) ) ) {
                
                NSString *errorDomain = [NSString stringWithFormat:@"the gas you cousume is: %@ You need add fee in this transaction.", totalGasPrice.decString];
                
                return handleBlock(nil, [NSError errorWithDomain:errorDomain code:-1 userInfo:nil]);
            }
            
            
            /// 签名和生成txid
            /// 有一些情况是需要先创建交易，但是不执行签名，比如 mulitsig get，需要从远程服务器请求签名的，所以增加这些判断
            if ( initorKeypair && authRequireKeypairs ) {
                
                NSError *signError;
                
                [self payloadSignTransaction:tx cryptoType:opt.globalFlags.cryptoType initorKeypair:initorKeypair authRequireKeypairs:authRequireKeypairs error:&signError];
                if ( signError ) {
                    return handleBlock(nil, signError);
                }
                
            }
            
            return handleBlock(tx, nil);
            
        }];

    }];
    
    return ;
}

/// 填充Transaction对象中缺失的签名， 签名会填充在传入的Transaction对象中，若出现异常，tx对象不会发生改变
/// \param tx 需要填充签名的交易
/// \param initorKeypair 事务发起人的密钥对
/// \param authRequireKeypairs 所需要的authRequire(ACL)的密钥对
/// \param error 错误捕获
+ (BOOL) payloadSignTransaction:(Transaction * _Nonnull)tx
                     cryptoType:(XCryptoTypeStringKey _Nonnull)cryptoType
                  initorKeypair:(id<XCryptoKeypairProtocol> _Nonnull)initorKeypair
            authRequireKeypairs:(NSArray<id<XCryptoKeypairProtocol>> *_Nonnull)authRequireKeypairs
                          error:(NSError * _Nullable * _Nonnull)error {
    
    if ( tx.initiatorSignsArray_Count != 0 ) {
        if (*error) *error = [NSError errorWithDomain:@"initiatorSigns is already exist." code:-1 userInfo:nil];
        return false;
    }
    
    if ( tx.authRequireSignsArray_Count != 0 ) {
        if (*error) *error = [NSError errorWithDomain:@"authRequireSigns is already exist." code:-1 userInfo:nil];
        return false;
    }
    
    @try {
        
        id<XCryptoClientProtocol> cryptoClient = [XCryptoFactory cryptoClientWithCryptoType:cryptoType];
        
        /// initor 签名
        if ( initorKeypair ) {
            
            SignatureInfo *initorSig = [tx txProcessSignInfoWithClient:cryptoClient keypair:initorKeypair error:error];
            if (*error) {
                @throw [NSException exceptionWithName:(*error).domain reason:(*error).description userInfo:nil];
            }
            
            [tx.initiatorSignsArray addObject:initorSig];
        }
        
        /// authRequire 签名
        if ( authRequireKeypairs ) {
            
            for ( id<XCryptoKeypairProtocol> aclKeypari in authRequireKeypairs ) {
            
                SignatureInfo *aclSign = [tx txProcessSignInfoWithClient:cryptoClient keypair:aclKeypari error:error];
                if (*error) {
                    @throw [NSException exceptionWithName:(*error).domain reason:(*error).description userInfo:nil];
                }
            
                [tx.authRequireSignsArray addObject:aclSign];
            }
        }
        
        if ( initorKeypair && authRequireKeypairs ) {
            tx.txid = tx.txMakeTransactionID;
        }
        
        return true;
        
    } @catch (NSException *exception) {
        
        [tx.initiatorSignsArray removeAllObjects];
        [tx.authRequireSignsArray removeAllObjects];
        tx.txid = [NSData data];
      
        if (error) *error = [NSError errorWithDomain:exception.name code:-1 userInfo:nil];
        return false;
    }

}

+ (void) payloadSignTransaction:(Transaction * _Nonnull)tx
                    initorSigns:(SignatureInfo * _Nonnull)initorSigns
               authRequireSigns:(NSArray<SignatureInfo *> *_Nonnull)authRequireSigns {
    
    return [tx payloadTxSigns:initorSigns authRequireSigns:authRequireSigns];
    
}

@end
