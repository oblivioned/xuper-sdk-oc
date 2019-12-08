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

@interface XProviderTester : XCTestCase

@property (nonatomic, strong) XClient *client;
@property (nonatomic, strong) XECDSAClient *cryptoClient;
@property (nonatomic, strong) id<XCryptoAccountProtocol> initorAccount;

@end

@implementation XProviderTester

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
- (void)test_SelectUTXO {  AsyncTestBegin(@"GRPC Test - SelectUTXO");
    
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

- (void)test_Connection { AsyncTestBegin(@"GRPC Test");

    CommonIn *msg = [CommonIn message];
    msg.header = CommonIn.getRandomHeader;
    
    [self.client getSystemStatusWithRequest:msg handler:^(SystemsStatusReply * _Nullable response, NSError * _Nullable error) {
    
        XCTAssertNil(error);
        XCTAssertNotNil(response);
    
        AsyncTestFulfill();
    }];
    
AsyncTestWaiting5S(); }

@end
