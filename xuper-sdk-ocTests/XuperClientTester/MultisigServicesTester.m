//
//  MultisigServicesTester.m
//  xuper-sdk-oc-iOSTests
//
//  Created by apple on 2019/12/8.
//  Copyright © 2019 Martin.Ren. All rights reserved.
//

#import <XCTest/XCTest.h>

#import <xuper_sdk_oc_iOS/xuper_sdk_oc_iOS.h>

#import "TestCommon.h"


@interface MultisigServicesTester : XCTestCase

@property (nonatomic, strong) XClient *client;

@property (nonatomic, strong) MultisigServices *signServices;

@property (nonatomic, strong) XECDSAAccount *initorAccount;

@end

@implementation MultisigServicesTester

- (void)setUp {
    
    self.client = [XClient clientWithGRPCHost:@"127.0.0.1:37101"];
      
    self.signServices = [[MultisigServices alloc] initWithClient:self.client bcname:@"xuper"];
    
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

/// 测试环境接入地址： 14.215.179.74:37101
/// 黄反服务的address： XDxkpQkfLwG6h56e896f3vBHhuN5g6M9u
/// 仅用于测试对应方法的正确性
- (void)test_getSignWithRemoteNodeURL {  AsyncTestBegin(@"MultisigServices - GetSignWithRemoteNodeURL");

    XTransactionDescInvoke *invoke = [[XTransactionDescInvoke alloc] init];
    invoke.authRequires = @[self.initorAccount.address];
    invoke.contractName = @"ERC20";
    invoke.moduleName = @"wasm";
    invoke.methodName = @"balance";
    invoke.args = @{
        @"caller" : @"Martin",
    };

    __block Transaction *unSignTx = NULL;
    XTransactionOpt *opt = [XTransactionOpt optWasmInvokeWithAddress:self.initorAccount.address invokeDesc:invoke forzenHeight:0];
    
    /// 计算手续费
//    XCTestExpectation *preExpectation = [self expectationWithDescription:@"PreExec"];
//    [self.signServices preExecOpt:opt handle:^(InvokeResponse * _Nullable response, NSError * _Nullable error) {
//        XCTAssertNotNil(response);
//        XCTAssertNil(error);
//        [preExpectation fulfill];
//    }];
//    [self waitForExpectations:@[preExpectation] timeout:3];
    
    
    /// 1.本地生成一个不带签名的交易，使用远端节点的地址
    XCTestExpectation *genExpectation = [self expectationWithDescription:@"GenTX"];
    [self.signServices genTransactionWithOption:opt handle:^(Transaction * _Nullable tx, NSError * _Nullable error) {
        XCTAssertNotNil(tx);
        XCTAssertNil(error);
        unSignTx = tx;
        [genExpectation fulfill];
    }];
    [self waitForExpectations:@[genExpectation] timeout:3];
    
    [self.signServices getSignWithTransaction:unSignTx
                            fromRemoteNodeURL:@"14.215.179.74:37101"
                            secureConnections:NO
                                       handle:^(SignatureInfo * _Nullable signInfo, NSError * _Nullable error) {
        XCTAssertNotNil(signInfo);
        XCTAssertNil(error);
        AsyncTestFulfill();
    }];
    
AsyncTestWaiting5S();}

/// 测试说明
/// 1.本地生成一个不带签名的交易
/// 2.时候sign签名后补充到Tx中
/// 3.发送交易
/// 4.检测是否可以成功发送，并且正确响应
- (void)test_genTransaction { AsyncTestBegin(@"MultisigServices - GenTransactionWithOption");
 
    XTransactionOpt *opt = [XTransactionOpt optTransferWithFrom:self.initorAccount.address to:@"eqMvtH1MQSejd4nzxDy21W1GW12cocrPF" amount:[[XBigInt alloc] initWithDecString:@"10"] remarks:@"MultisigServices - GenTransactionWithOption" forzenHeight:0];
    
    __block Transaction *unSignTx = NULL;
    
    /// 1.本地生成一个不带签名的交易，使用远端节点的地址
    XCTestExpectation *genExpectation = [self expectationWithDescription:@"GenTX"];
    [self.signServices genTransactionWithOption:opt handle:^(Transaction * _Nullable tx, NSError * _Nullable error) {
        
        XCTAssertNotNil(tx);
        XCTAssertNil(error);
        unSignTx = tx;
        [genExpectation fulfill];
        
    }];
    [self waitForExpectations:@[genExpectation] timeout:3];
    
    /// 2.用这个交易去远端地址中请求签名
    NSError *error;
    SignatureInfo *initorSig = [self.signServices signTransaction:unSignTx cryptoType:XCryptoTypeStringKeyDefault keypair:self.initorAccount error:&error];
    XCTAssertNotNil(initorSig);
    XCTAssertNil(error);
    
    XCTAssertFalse([unSignTx verifyWithCryptoType:XCryptoTypeStringKeyDefault error:&error], "verifyWithCryptoType must be false in here.");
    
    error = nil;
    Transaction *signedTx = unSignTx;
    [signedTx payloadTxSigns:initorSig authRequireSigns:@[initorSig]];
    
    XCTAssertTrue([signedTx verifyWithCryptoType:XCryptoTypeStringKeyDefault error:&error], "verifyWithCryptoType must be true in here.");
    
    /// 3.发送交易
    [self.signServices sendSignedTransaction:signedTx cryptoType:XCryptoTypeStringKeyDefault handle:^(BOOL success, NSError * _Nullable error) {
        
        XCTAssertTrue(success);
        XCTAssertNil(error);
        
        AsyncTestFulfill();
    }];
    NSLog(@"TXID:%@", signedTx.txid.xHexString);
    
AsyncTestWaiting5S();}

@end
