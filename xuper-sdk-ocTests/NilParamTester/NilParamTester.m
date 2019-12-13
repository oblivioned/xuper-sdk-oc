//
//  NilParamTester.m
//  xuper-sdk-oc-iOSTests
//
//  Created by apple on 2019/12/13.
//  Copyright © 2019 Martin.Ren. All rights reserved.
//

#import "TestCommon.h"

@interface NilParamTester : XCTestCase

@end

@implementation NilParamTester

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)test_AccountServices {
    
    [T.xuperClient.account balanceWithAddress:T.initor.address handle:^(XBigInt * _Nullable n, NSError * _Nullable error) {
        
    }];
    
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
