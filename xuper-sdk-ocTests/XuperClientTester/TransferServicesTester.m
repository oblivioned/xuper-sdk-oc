//
//  TransferServicesTester.m
//  xuper-sdk-oc-iOSTests
//
//  Created by apple on 2019/12/9.
//  Copyright © 2019 Martin.Ren. All rights reserved.
//

#import <XCTest/XCTest.h>

#import <xuper_sdk_oc_iOS/xuper_sdk_oc_iOS.h>

#import "TestCommon.h"

@interface TransferServicesTester : XCTestCase

@property (nonatomic, strong) XClient *client;

@property (nonatomic, strong) TransferServices *transferServices;

@property (nonatomic, strong) XECDSAAccount *initorAccount;

@end

@implementation TransferServicesTester

- (void)setUp {
    
    self.client = [XClient clientWithGRPCHost:@"127.0.0.1:37101"];
          
    self.transferServices = [[TransferServices alloc] initWithClient:self.client bcname:@"xuper"];
    
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

- (void)test_Transfer { AsyncTestBegin(@"TransferServices - Transfer");
    
    XBigInt *one = [[XBigInt alloc] initWithDecString:@"1"];
    
    [self.transferServices transferWithFrom:self.initorAccount.address
                                         to:@"eqMvtH1MQSejd4nzxDy21W1GW12cocrPF"
                                     amount:one
                                    remarks:nil
                               forzenHeight:0
                              initorKeypair:self.initorAccount
                        authRequireKeypairs:@[self.initorAccount] handle:^(XHexString  _Nullable txhash, NSError * _Nullable error) {
       
        XCTAssertNotNil(txhash);
        XCTAssertNil(error);
        
        NSLog(@"TXID:%@", txhash);
        
        AsyncTestFulfill();
        
    }];
    
AsyncTestWaiting5S();}

@end
