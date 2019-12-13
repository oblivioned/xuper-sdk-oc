//
//  MultisigServicesTester.m
//  xuper-sdk-oc-iOSTests
//
//  Created by apple on 2019/12/8.
//  Copyright © 2019 Martin.Ren. All rights reserved.
//

#import "TestCommon.h"

@interface MultisigServicesTester : XCTestCase

@end

@implementation MultisigServicesTester

- (void)setUp {
    
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

/// 测试环境接入地址： 14.215.179.74:37101
/// 黄反服务的address： XDxkpQkfLwG6h56e896f3vBHhuN5g6M9u
/// 仅用于测试对应方法的正确性
- (void)test_GetSignWithRemoteNodeURL {  AsyncTestBegin(@"MultisigServices - GetSignWithRemoteNodeURL");

    XTransactionDescInvoke *invoke = [[XTransactionDescInvoke alloc] init];
    invoke.authRequires = @[T.initor.address];
    invoke.contractName = @"ERC20";
    invoke.moduleName = @"wasm";
    invoke.methodName = @"balance";
    invoke.args = @{
        @"caller" : @"Martin",
    };

    __block Transaction *unSignTx = NULL;
    XTransactionOpt *opt = [XTransactionOpt optWasmInvokeWithAddress:T.initor.address invokeDesc:invoke forzenHeight:0];
    
    /// 1.本地生成一个不带签名的交易，使用远端节点的地址
    XCTestExpectation *genExpectation = [self expectationWithDescription:@"GenTX"];
    [T.xuperClient.multisig genTransactionWithOption:opt
                                       initorKeypair:nil
                                 authRequireKeypairs:nil
                                              handle:^(Transaction * _Nullable tx, NSError * _Nullable error) {
        XCTAssertNotNil(tx);
        XCTAssertNil(error);
        unSignTx = tx;
        [genExpectation fulfill];
    }];
    [self waitForExpectations:@[genExpectation] timeout:3];
    
    [T.xuperClient.multisig getSignWithTransaction:unSignTx
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
- (void)test_Gen_Sign_SendTransaction { AsyncTestBegin(@"MultisigServices - GenTransactionWithOption");
 
    XTransactionOpt *opt = [XTransactionOpt optTransferWithFrom:T.initor.address to:T.toAddress amount:[[XBigInt alloc] initWithDecString:@"10"] remarks:@"MultisigServices - GenTransactionWithOption" forzenHeight:0];
    
    __block Transaction *unSignTx = NULL;
    
    /// 1.本地生成一个不带签名的交易，使用远端节点的地址
    XCTestExpectation *genExpectation = [self expectationWithDescription:@"GenTX"];
    [T.xuperClient.multisig genTransactionWithOption:opt
                                       initorKeypair:nil
                                 authRequireKeypairs:nil
                                              handle:^(Transaction * _Nullable tx, NSError * _Nullable error) {
        
        XCTAssertNotNil(tx);
        XCTAssertNil(error);
        unSignTx = tx;
        [genExpectation fulfill];
        
    }];
    [self waitForExpectations:@[genExpectation] timeout:3];
    
    /// 2.用这个交易去远端地址中请求签名
    NSError *error;
    SignatureInfo *initorSig = [T.xuperClient.multisig signTransaction:unSignTx cryptoType:XCryptoTypeStringKeyDefault keypair:T.initor error:&error];
    XCTAssertNotNil(initorSig);
    XCTAssertNil(error);
    XCTAssertFalse([unSignTx verifyWithCryptoType:XCryptoTypeStringKeyDefault error:&error], "verifyWithCryptoType must be false in here.");
    
    error = nil;
    Transaction *signedTx = unSignTx;
    [signedTx payloadTxSigns:initorSig authRequireSigns:@[initorSig]];
    
    XCTAssertTrue([signedTx verifyWithCryptoType:XCryptoTypeStringKeyDefault error:&error], "verifyWithCryptoType must be true in here.");
    
    /// 3.发送交易
    [T.xuperClient.multisig sendSignedTransaction:signedTx cryptoType:XCryptoTypeStringKeyDefault handle:^(BOOL success, NSError * _Nullable error) {
        
        XCTAssertTrue(success);
        XCTAssertNil(error);
        
        AsyncTestFulfill();
    }];
    NSLog(@"TXID:%@", signedTx.txid.xHexString);
    
AsyncTestWaiting5S();}

@end
