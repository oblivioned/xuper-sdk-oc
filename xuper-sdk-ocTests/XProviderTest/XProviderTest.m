//
//  XProviderTest.m
//  xuper-sdk-oc-iOSTests
//
//  Created by apple on 2019/12/4.
//  Copyright © 2019 Martin.Ren. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <xuper_sdk_oc_iOS/xuper_sdk_oc_iOS.h>
#import "TestCommon.h"

@interface XProviderTest : XCTestCase

@property (nonatomic, strong) XClient *client;
@property (nonatomic, strong) XECDSAClient *cryptoClient;
@property (nonatomic, strong) id<XCryptoAccountProtocol> initorAccount;

@end

@implementation XProviderTest

- (void)setUp {
    
    // Put setup code here. This method is called before the invocation of each test method in the class.
    self.client = [XClient clientWithGRPCHost:@"127.0.0.1:37101"];
    
    self.cryptoClient = [[XECDSAClient alloc] init];
    
    XECDSAPrivKey *accountPk = [XECDSAPrivKey fromExportedDictionary:@{
        @"Curvname":@"P-256",
        @"X":@"74695617477160058757747208220371236837474210247114418775262229497812962582435",
        @"Y":@"51348715319124770392993866417088542497927816017012182211244120852620959209571",
        @"D":@"29079635126530934056640915735344231956621504557963207107451663058887647996601"
    }];
    
    self.initorAccount = [XECDSAAccount fromPrivateKey:accountPk];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

/// 转账交易中，只需要from的地址
- (void)testselectUTXO {  AsyncTestBegin(@"GRPC Test - SelectUTXO");
    
    UtxoInput *ui = [UtxoInput message];
    ui.bcname = @"xuper";
    ui.address = @"dpzuVdosQrF2kmzumhVeFQZa1aYcdgFpN";
    ui.totalNeed = @"100";
    ui.needLock = true;
    
    [self.client selectUTXOWithRequest:ui handler:^(UtxoOutput * _Nullable response, NSError * _Nullable error) {
        XCTAssertNil(error);
        XCTAssertNotNil(response);
        AsyncTestFulfill();
    }];
    
AsyncTestWaiting5S(); }

- (void)testConnection { AsyncTestBegin(@"GRPC Test");

    CommonIn *msg = [CommonIn message];
    msg.header = self.client.providerConfigure.randomHeader;
    
    [self.client getSystemStatusWithRequest:msg handler:^(SystemsStatusReply * _Nullable response, NSError * _Nullable error) {
    
        XCTAssertNil(error);
        XCTAssertNotNil(response);
    
        AsyncTestFulfill();
    }];
    
AsyncTestWaiting5S(); }

- (void) testTrnasfer { AsyncTestBegin(@"GRPC Test - Trnasfer");
    
    Transaction *tx = [Transaction message];
    
    ///--txversion int32      tx version (default 1)
    tx.version = 1;
    tx.coinbase = false;
    tx.desc = [@"transfer from console" dataUsingEncoding:NSUTF8StringEncoding];
    /// 18 bytes random number
    tx.nonce = @"157545959798498081";
    /// 18 位时间戳，如果无法获取对应的精度，右侧补0，凑齐18位
    tx.timestamp = 1575459597891511000L;
    tx.initiator = @"dpzuVdosQrF2kmzumhVeFQZa1aYcdgFpN";
    
    
//    @"dpzuVdosQrF2kmzumhVeFQZa1aYcdgFpN",
//    @"WNWk3ekXeM5M2232dY2uCJmEqWhfQiDYT",
    TxDataAccount *to = [TxDataAccount message];
    to.address = @"WNWk3ekXeM5M2232dY2uCJmEqWhfQiDYT";
    to.amount = @"100";
    to.frozenHeight = -1;
    
    /// 暂时使用openssl中的BN来转换,测试用例中不在释放bn_amount对象了
    BIGNUM *totalNeed = BN_new();
    BN_dec2bn(&totalNeed, "100");
    
    unsigned char *bin_totalNeed = malloc(BN_num_bytes(totalNeed));
    BN_bn2bin(totalNeed, bin_totalNeed);
    
    ///组装output
    TxOutput *output = [TxOutput message];
    
    /// totalNeed 和 amount 是要分开的，自处因为数值相同，就直接只用同一个对象
    output.toAddr = [to.address dataUsingEncoding:NSUTF8StringEncoding];
    output.amount = [NSData dataWithBytes:bin_totalNeed length:BN_num_bytes(totalNeed)];
    output.frozenHeight = to.frozenHeight;
    [tx.txOutputsArray addObject:output];
    
    // 组装input 和 剩余output
    UtxoInput *ui = [UtxoInput message];
    ui.bcname = @"xuper";
    ui.address = @"dpzuVdosQrF2kmzumhVeFQZa1aYcdgFpN";
    ui.totalNeed = [[NSString alloc] initWithUTF8String:(const char*)BN_bn2dec(totalNeed)];
    ui.needLock = true;

    XCTestExpectation *expectationSelectUTXO = [self expectationWithDescription:@"selectUTXO"];
    __block UtxoOutput *utxoRes = NULL;
    [self.client selectUTXOWithRequest:ui handler:^(UtxoOutput * _Nullable response, NSError * _Nullable error) {
        utxoRes = response;
        [expectationSelectUTXO fulfill];
    }];
    [self waitForExpectations:@[expectationSelectUTXO] timeout:3];
    
    if ( !utxoRes ) {
        XCTFail(@"selectUTXOWithRequest response's UtxoOutput is vaild.");
        return ;
    }
    
    /// 类似BTC的找零机制，先把自己的所有交易作为输入交易，s然后转出制定的资源以后，剩余的交易写给自己 ？？？
    NSMutableArray<TxInput*> *txTxInputs = [[NSMutableArray alloc] init];
    TxOutput *tx_output = [TxOutput message];
    
    for (Utxo *utxo in utxoRes.utxoListArray) {
        
        TxInput *txinputIt = [TxInput message];
        
        txinputIt.refTxid = utxo.refTxid;
        
        txinputIt.refOffset = utxo.refOffset;
        
        txinputIt.fromAddr = utxo.toAddr;
        
        txinputIt.amount = utxo.amount;
        
        [txTxInputs addObject:txinputIt];
    }
    
    /// 一个十进制的数字字符串
//    utxoRes.totalSelected
    BIGNUM *bn_totalSelected = BN_new();
    BN_dec2bn(&bn_totalSelected, utxoRes.totalSelected.UTF8String);
    
    BIGNUM *bn_totalNeed = BN_new();
    BN_dec2bn(&bn_totalNeed, ui.totalNeed.UTF8String);
    
    // 多出来的utxo需要再转给自己
    if ( BN_cmp(bn_totalSelected, bn_totalNeed) > 0 ) {
        
        BIGNUM *delta = BN_new();
        BN_sub(delta, bn_totalSelected, bn_totalNeed);
        
        unsigned char *bin_delta = malloc(BN_num_bytes(delta));
        BN_bn2bin(delta, bin_delta);
        
        tx_output.toAddr = [@"dpzuVdosQrF2kmzumhVeFQZa1aYcdgFpN" dataUsingEncoding:NSUTF8StringEncoding];
        tx_output.amount = [NSData dataWithBytes:bin_delta length:BN_num_bytes(delta)];
    }
    
    ///txTxInputs,tx_output
    tx.txInputsArray = txTxInputs;
    [tx.txOutputsArray addObject:tx_output];
    
    /// 设置auth require
    /// 转账交易中，只需要from的地址
    /// tx.authRequireArray = [[NSMutableArray alloc] initWithObjects:@"dpzuVdosQrF2kmzumhVeFQZa1aYcdgFpN", nil];
    [tx.authRequireArray addObject:@"dpzuVdosQrF2kmzumhVeFQZa1aYcdgFpN"];
    
    /// 进行一个预发送流程，不真正执行交易
    InvokeRPCRequest *preExeRPCReq = [InvokeRPCRequest message];
    preExeRPCReq.bcname = @"xuper";
//    preExeRPCReq.requestsArray = [[NSMutableArray alloc] init];
    preExeRPCReq.header = self.client.providerConfigure.randomHeader;
    preExeRPCReq.initiator = @"dpzuVdosQrF2kmzumhVeFQZa1aYcdgFpN";
    preExeRPCReq.authRequireArray = tx.authRequireArray;

    XCTestExpectation *expectationInvoke = [self expectationWithDescription:@"InvokeRPCResponse"];
    __block InvokeRPCResponse * preExeRes = NULL;
    [self.client preExecWithRequest:preExeRPCReq handler:^(InvokeRPCResponse * _Nullable response, NSError * _Nullable error) {
        preExeRes = response;
        [expectationInvoke fulfill];
    }];
    [self waitForExpectations:@[expectationInvoke] timeout:3];
    
//    tx.ContractRequests = preExeRes.GetResponse().GetRequests()
//    tx.TxInputsExt = preExeRes.GetResponse().GetInputs()
//    tx.TxOutputsExt = preExeRes.GetResponse().GetOutputs()
    tx.contractRequestsArray = preExeRes.response.requestsArray;
    tx.txInputsExtArray = preExeRes.response.inputsArray;
    tx.txOutputsExtArray = preExeRes.response.outputsArray;
    
    TxStatus *tx_status = [TxStatus message];
    tx_status.header = self.client.providerConfigure.randomHeader;
    tx_status.bcname = @"xuper";
    tx_status.status = TransactionStatus_Unconfirm;
    tx_status.tx = tx;
    
    // 签名和生成txid
    /// initor签名
    NSError *signError;
    SignatureInfo *initorSig = [tx txProcessSignInfoWithClient:self.cryptoClient keypair:self.initorAccount error:&signError];
    XCTAssertNil(signError, "use ECDSA crypto client signature tx hash error.");
    [tx_status.tx.initiatorSignsArray addObject:initorSig];
    
    /// authRequire签名,简单的转账没有别的authRequire，所以签名和initor的一致，因为AuthReuire只有initor自己一个地址
    [tx_status.tx.authRequireSignsArray addObject:initorSig];
    
    /// 生成txid，实际上应该是该交易的具体hash值
    tx_status.tx.txid = tx.txMakeTransactionID;
    tx_status.txid = tx_status.tx.txid;
    
    NSLog(@"TransactionID:%@", tx_status.txid.xHexString);
    
    XCTestExpectation *expectationPostTx = [self expectationWithDescription:@"PostTxWithRequest"];
    [self.client postTxWithRequest:tx_status handler:^(CommonReply * _Nullable response, NSError * _Nullable error) {
        XCTAssertNil(error);
        XCTAssertNotNil(response);
        XCTAssert(response.header.error != XChainErrorEnum_TxVerificationError);
        [expectationPostTx fulfill];
    }];
    [self waitForExpectations:@[expectationPostTx] timeout:5];
    
    
    TxStatus *txQueryMessage = [TxStatus message];
    txQueryMessage.header = self.client.providerConfigure.randomHeader;
    txQueryMessage.txid = tx_status.txid;
    txQueryMessage.bcname = @"xuper";
    [self.client queryTxWithRequest:txQueryMessage handler:^(TxStatus * _Nullable response, NSError * _Nullable error) {
        printf("QueryTxResponse:\n");
        printf("%s\n", response.tx.description.UTF8String);
        AsyncTestFulfill();
    }];
    
AsyncTestWaiting5S(); }


- (void)testTxHash {
    
    Transaction *tx = [Transaction message];
    
    ///--txversion int32      tx version (default 1)
    tx.version = 1;
    tx.coinbase = false;
    tx.desc = [@"transfer from console" dataUsingEncoding:NSUTF8StringEncoding];
    /// 18 bytes random number
    tx.nonce = @"157545959798498081";
    /// 18 位时间戳，如果无法获取对应的精度，右侧补0，凑齐18位
    tx.timestamp = 1575459597891511000L;
    tx.initiator = @"dpzuVdosQrF2kmzumhVeFQZa1aYcdgFpN";
    
    /// output
    TxDataAccount *to = [TxDataAccount message];
    to.address = @"WNWk3ekXeM5M2232dY2uCJmEqWhfQiDYT";
    to.amount = @"100";
    to.frozenHeight = -1;
       
    /// 暂时使用openssl中的BN来转换,测试用例中不在释放bn_amount对象了
    BIGNUM *totalNeed = BN_new();
    BN_dec2bn(&totalNeed, "100");
   
    unsigned char *bin_totalNeed = malloc(BN_num_bytes(totalNeed));
    BN_bn2bin(totalNeed, bin_totalNeed);
   
    ///组装output
    TxOutput *output = [TxOutput message];
   
    /// totalNeed 和 amount 是要分开的，自处因为数值相同，就直接只用同一个对象
    output.toAddr = [to.address dataUsingEncoding:NSUTF8StringEncoding];
    output.amount = [NSData dataWithBytes:bin_totalNeed length:BN_num_bytes(totalNeed)];
    output.frozenHeight = -1;
    [tx.txOutputsArray addObject:output];
    
    /// 组装input
    TxInput *input = [TxInput message];
    input.refTxid = [@"RefTxid" dataUsingEncoding:NSUTF8StringEncoding];
    input.refOffset = 0;
    input.fromAddr = [@"dpzuVdosQrF2kmzumhVeFQZa1aYcdgFpN" dataUsingEncoding:NSUTF8StringEncoding];
    input.amount = [NSData dataWithBytes:bin_totalNeed length:BN_num_bytes(totalNeed)];
    input.frozenHeight = -1;
    [tx.txInputsArray addObject:input];
    
    NSLog(@"xuper-sdk-oc txHash:%@", tx.txMakeDigestHash.xHexString);
    NSLog(@"xuper-sdk-oc txID:%@", tx.txMakeTransactionID.xHexString);
}

@end
