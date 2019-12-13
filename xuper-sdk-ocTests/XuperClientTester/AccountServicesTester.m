//
//  TestAccountServices.m
//  xuper-sdk-oc-iOSTests
//
//  Created by apple on 2019/12/6.
//  Copyright © 2019 Martin.Ren. All rights reserved.
//

#import "TestCommon.h"

@interface AccountServicesTester : XCTestCase
@property (nonatomic, strong) XuperClient* client;
@end

@implementation AccountServicesTester

- (void)setUp {
    self.client = T.xuperClient;
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)test_BalanceOf { AsyncTestBegin(@"AccountServices - Account Balance");
    
    /// 测试获取可用余额
    [self.client.account balanceWithAddress:T.initor.address handle:^(XBigInt * _Nullable n, NSError * _Nullable error) {
        XCTAssertNil(error);
        XCTAssertNotNil(n);
        NSLog(@"Balance:%@", n.decString);
    }];
    
    /// 测试获取冻结余额
    [self.client.account balanceFrozenWithAddress:T.initor.address handle:^(XBigInt * _Nullable n, NSError * _Nullable error) {
        XCTAssertNil(error);
        XCTAssertNotNil(n);
        NSLog(@"Frozen:%@", n.decString);
        
        AsyncTestFulfill();
    }];
    
    
AsyncTestWaiting5S(); }

- (void)test_AccountContracts { AsyncTestBegin(@"AccountServices - Account Contracts");
    
    [self.client.account contractsWithAccount:T.account handle:^(NSArray<ContractStatus *> * _Nullable contracts, NSError * _Nullable error) {
        XCTAssertNil(error);
        XCTAssert(contracts && contracts.count > 0);
        
        for ( ContractStatus *contract in contracts  ) {
            NSLog(@"ContractName:%@", contract.contractName);
        }
        
        AsyncTestFulfill();
    }];
    
AsyncTestWaiting5S(); }


- (void)test_NewKeys {
    
    XECDSAAccount *account = (XECDSAAccount*)[self.client.account newKeysWithCryptoType:nil];
    
    XCTAssertNotNil(account);
    XCTAssertNotNil(account.address);
    XCTAssertNotNil(account.publicKey);
    XCTAssertNotNil(account.privateKey);
    XCTAssertNotNil(account.publicKey.jsonFormatString);
    XCTAssertNotNil(account.privateKey.jsonFormatString);
}

- (void)test_QueryAccounts { AsyncTestBegin(@"AccountServices - Query Accounts");
    
    [self.client.account queryAccountListWithAddress:T.initor.address handle:^(NSArray<XAccount> * _Nullable accounts, NSError * _Nullable error) {
        XCTAssertNil(error);
        AsyncTestFulfill();
    }];
    
AsyncTestWaiting5S(); }

- (void)test_NewAccount { AsyncTestBegin(@"AccountServices - New Account");
        
    XTransactionACL *acl = [[XTransactionACL alloc] init];
    
    acl.pm.rule = XTransactionPMRuleDefault;
    acl.pm.acceptValue = 0.6;
    acl.aksWeight[T.initor.address] = @(0.5);
    acl.aksWeight[T.toAddress] = @(0.5);
    
    [self.client.account newAccountWithAddress:T.initor.address
                                            acl:acl
                                  initorKeypair:T.initor
                                       feeAsker:nil
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
