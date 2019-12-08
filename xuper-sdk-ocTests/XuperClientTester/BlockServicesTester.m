//
//  BlockServicesTester.m
//  xuper-sdk-oc-iOSTests
//
//  Created by apple on 2019/12/8.
//  Copyright © 2019 Martin.Ren. All rights reserved.
//

#import <XCTest/XCTest.h>

#import <xuper_sdk_oc_iOS/xuper_sdk_oc_iOS.h>

#import "TestCommon.h"

@interface BlockServicesTester : XCTestCase

@property (nonatomic, strong) XClient *client;

@property (nonatomic, strong) BlockServices *blockServices;

@end

@implementation BlockServicesTester

- (void)setUp {
    
    // Put setup code here. This method is called before the invocation of each test method in the class.
    self.client = [XClient clientWithGRPCHost:@"127.0.0.1:37101"];
      
    self.blockServices = [[BlockServices alloc] initWithClient:self.client bcname:@"xuper"];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)test_BlockWithID { AsyncTestBegin(@"BlockServices - GetBlockWithID");
 
    [self.blockServices blockWithID:@"d1577f91bff29ee02ef2484db1640c331cf4c0356b5b9de7decc1ac884869629" needContent:YES handle:^(XBlock * _Nullable block, NSError * _Nullable error) {
        
        XCTAssertNotNil(block);
        XCTAssertNil(error);
        XCTAssert(block.blockid.length > 0);
        
        AsyncTestFulfill();
        
    }];
    
AsyncTestWaiting5S();}

- (void)test_BlockWithHeight { AsyncTestBegin(@"ACLServices - GetBlockWithHeight");
 
    [self.blockServices blockWithHeight:1000 handle:^(XBlock * _Nullable block, NSError * _Nullable error) {
        
        XCTAssertNotNil(block);
        XCTAssertNil(error);
        XCTAssert(block.blockid.length > 0);
        
        AsyncTestFulfill();
        
    }];
    
AsyncTestWaiting5S();}

@end
