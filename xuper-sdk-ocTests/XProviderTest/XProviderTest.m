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
@end

@implementation XProviderTest

- (void)setUp {
    
    // Put setup code here. This method is called before the invocation of each test method in the class.
    self.client = [XClient clientWithGRPCHost:@"127.0.0.1:37101"];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testConnection {

    AsyncTestBegin(@"GRPC Test");
    
    CommonIn *msg = [CommonIn message];
    msg.header = self.client.providerConfigure.randomHeader;
    
    [self.client getSystemStatusWithRequest:msg handler:^(SystemsStatusReply * _Nullable response, NSError * _Nullable error) {
    
        XCTAssertNil(error);
        XCTAssertNotNil(response);
    
        AsyncTestFulfill();
    }];
    
    AsyncTestWaiting5S();
}

@end
