//
//  StatusServicesTester.m
//  xuper-sdk-oc-iOSTests
//
//  Created by apple on 2019/12/9.
//  Copyright © 2019 Martin.Ren. All rights reserved.
//

#import "TestCommon.h"

@interface StatusServicesTester : XCTestCase

@end

@implementation StatusServicesTester

- (void)setUp {
    
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)test_Status { AsyncTestBegin(@"StatusServices - Status");
    
    [T.xuperClient.status statusWithHandle:^(SystemsStatus * _Nullable status, NSError * _Nullable error) {
        
        XCTAssertNotNil(status);
        XCTAssertNil(error);
        
        AsyncTestFulfill();
    }];
    
AsyncTestWaiting5S();}


@end
