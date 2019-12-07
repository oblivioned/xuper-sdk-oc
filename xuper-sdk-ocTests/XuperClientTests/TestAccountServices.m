//
//  TestAccountServices.m
//  xuper-sdk-oc-iOSTests
//
//  Created by apple on 2019/12/6.
//  Copyright © 2019 Martin.Ren. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <xuper_sdk_oc_iOS/xuper_sdk_oc_iOS.h>

#import "TestCommon.h"

@interface TestAccountServices : XCTestCase

@property (nonatomic, strong) XClient *client;

///dpzuVdosQrF2kmzumhVeFQZa1aYcdgFpN
@property (nonatomic, strong) XECDSAAccount *initorAccount;

@property (nonatomic, strong) AccountServices *accountServices;

@property (nonatomic, strong) XAccount testCaseAccount;

@end

@implementation TestAccountServices

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
    self.client = [XClient clientWithGRPCHost:@"127.0.0.1:37101"];
    self.accountServices = [[AccountServices alloc] initWithClient:self.client bcname:@"xuper"];
    
    XECDSAPrivKey *accountPk = [XECDSAPrivKey fromExportedDictionary:@{
        @"Curvname":@"P-256",
        @"X":@"74695617477160058757747208220371236837474210247114418775262229497812962582435",
        @"Y":@"51348715319124770392993866417088542497927816017012182211244120852620959209571",
        @"D":@"29079635126530934056640915735344231956621504557963207107451663058887647996601"
    }];
    
    self.testCaseAccount = @"XC1574829805000000@xuper";
    self.initorAccount = [XECDSAAccount fromPrivateKey:accountPk];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testBalanceOf { AsyncTestBegin(@"AccountServices - Account Balance");
    
    /// 测试获取可用余额
    [self.accountServices balanceWithAddress:self.initorAccount.address handle:^(XBigInt * _Nullable n, NSError * _Nullable error) {
        XCTAssertNil(error);
        XCTAssertNotNil(n);
        NSLog(@"Balance:%@", n.decString);
    }];
    
    /// 测试获取冻结余额
    [self.accountServices balanceFrozenWithAddress:self.initorAccount.address handle:^(XBigInt * _Nullable n, NSError * _Nullable error) {
        XCTAssertNil(error);
        XCTAssertNotNil(n);
        NSLog(@"Frozen:%@", n.decString);
        
        AsyncTestFulfill();
    }];
    
    
AsyncTestWaiting5S(); }

- (void)testAccountContracts { AsyncTestBegin(@"AccountServices - Account Contracts");
    
    [self.accountServices contractsWithAccount:@"XC1574829805000000@xuper" handle:^(NSArray<ContractStatus *> * _Nullable contracts, NSError * _Nullable error) {
        XCTAssertNil(error);
        XCTAssert(contracts && contracts.count > 0);
        
        for ( ContractStatus *contract in contracts  ) {
            NSLog(@"ContractName:%@", contract.contractName);
        }
        
        AsyncTestFulfill();
    }];
    
AsyncTestWaiting5S(); }


- (void)testNewKeys {
    
    XECDSAAccount *account = (XECDSAAccount*)[self.accountServices newKeysWithCryptoType:nil];
    
    XCTAssertNotNil(account);
    XCTAssertNotNil(account.address);
    XCTAssertNotNil(account.publicKey);
    XCTAssertNotNil(account.privateKey);
    XCTAssertNotNil(account.publicKey.jsonFormatString);
    XCTAssertNotNil(account.privateKey.jsonFormatString);
}

- (void)testQueryAccounts { AsyncTestBegin(@"AccountServices - Query Accounts");
    
    [self.accountServices queryAccountListWithAddress:self.initorAccount.address handle:^(NSArray<XAccount> * _Nullable accounts, NSError * _Nullable error) {
        XCTAssertNil(error);
        
        AsyncTestFulfill();
    }];
    
AsyncTestWaiting5S(); }

- (void)testNewAccount { AsyncTestBegin(@"AccountServices - New Account");
    
//    // 组装input 和 剩余output
//    UtxoInput *ui = [UtxoInput message];
//    ui.header = UtxoInput.getRandomHeader;
//    ui.bcname = @"xuper";
//    ui.address = self.initorAccount.address;
//    ui.totalNeed = @"0";
//    ui.needLock = false;
//
//    XCTestExpectation *expectation = [self expectationWithDescription:@"SelectUTXO"];
//    [self.client selectUTXOWithRequest:ui handler:^(UtxoOutput * _Nullable response, NSError * _Nullable error) {
//
//        [expectation fulfill];
//
//    }];
//
//    [self waitForExpectations:expectation timeout:5];
    
    XTransactionACL *acl = [XTransactionACL simpleACLWithAddress:self.initorAccount.address];
    
    [self.accountServices newAccountWithAddress:self.initorAccount.address acl:acl initorKeypair:self.initorAccount
                                            fee:[[XBigInt alloc] initWithDecString:@"1000"]
                                         handle:^(XAccount  _Nullable account, XHexString  _Nullable txhash, NSError * _Nullable error) {
        
        XCTAssertNotNil(account);
        XCTAssertNotNil(txhash);
        XCTAssertNil(error);
        
        NSLog(@"Account:%@", account);
        NSLog(@"TxHash:%@", txhash);
        
        AsyncTestFulfill();
    }];
    
AsyncTestWaiting5S(); }

@end
