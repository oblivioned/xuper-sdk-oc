//
//  TestACLServices.m
//  xuper-sdk-oc-iOSTests
//
//  Created by apple on 2019/12/8.
//  Copyright © 2019 Martin.Ren. All rights reserved.
//

#import <XCTest/XCTest.h>

#import <xuper_sdk_oc_iOS/xuper_sdk_oc_iOS.h>

#import "TestCommon.h"

@interface ACLServicesTester : XCTestCase

@property (nonatomic, strong) XClient *client;

@property (nonatomic, strong) ACLServices *aclServices;

@property (nonatomic, strong) XAccount testCaseAccount;

@end

@implementation ACLServicesTester

- (void)setUp {
    
    // Put setup code here. This method is called before the invocation of each test method in the class.
    self.client = [XClient clientWithGRPCHost:@"127.0.0.1:37101"];
    
    self.aclServices = [[ACLServices alloc] initWithClient:self.client bcname:@"xuper"];
  
    self.testCaseAccount = @"XC1574829805000000@xuper";
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)test_QueryACL { AsyncTestBegin(@"ACLServices - QueryACL");
 
    [self.aclServices queryWithAccount:self.testCaseAccount handle:^(XTransactionACL * _Nullable acl, NSError * _Nullable error) {
         
        XCTAssertNotNil(acl);
        XCTAssertNil(error);
        AsyncTestFulfill();
        
    }];
    
AsyncTestWaiting5S();}

@end
