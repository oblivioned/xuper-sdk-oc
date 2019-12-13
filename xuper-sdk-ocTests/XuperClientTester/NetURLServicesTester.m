//
//  NetURLServicesTester.m
//  xuper-sdk-oc-iOSTests
//
//  Created by apple on 2019/12/12.
//  Copyright © 2019 Martin.Ren. All rights reserved.
//

#import "TestCommon.h"

@interface NetURLServicesTester : XCTestCase

@end

@implementation NetURLServicesTester

- (void)test_GetNetURL { AsyncTestBegin(@"NetURLServices - Get");
    
    [T.xuperClient.netURL getNetURLWithHandle:^(NSString * _Nullable neturl, NSError * _Nullable error) {
        XCTAssertNotNil(neturl);
        XCTAssertNil(error);
        AsyncTestFulfill();
    }];
    
AsyncTestWaiting5S(); }

@end
