//
//  StatusServicesTester.m
//  xuper-sdk-oc-iOSTests
//
//  Created by apple on 2019/12/9.
//  Copyright © 2019 Martin.Ren. All rights reserved.
//

#import <XCTest/XCTest.h>

#import <xuper_sdk_oc_iOS/xuper_sdk_oc_iOS.h>

#import "TestCommon.h"

@interface StatusServicesTester : XCTestCase

@property (nonatomic, strong) XClient *client;

@property (nonatomic, strong) StatusServices *statusServices;

@end

@implementation StatusServicesTester

- (void)setUp {
    
    self.client = [XClient clientWithGRPCHost:@"127.0.0.1:37101"];
          
    self.statusServices = [[StatusServices alloc] initWithClient:self.client bcname:@"xuper"];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)test_Status { AsyncTestBegin(@"StatusServices - Status");
    
    [self.statusServices statusWithHandle:^(SystemsStatus * _Nullable status, NSError * _Nullable error) {
        
        XCTAssertNotNil(status);
        XCTAssertNil(error);
        
        AsyncTestFulfill();
    }];
    
AsyncTestWaiting5S();}


@end
