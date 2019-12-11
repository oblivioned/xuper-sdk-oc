//
//  TxServicesTester.m
//  xuper-sdk-oc-iOSTests
//
//  Created by apple on 2019/12/10.
//  Copyright © 2019 Martin.Ren. All rights reserved.
//

#import "TestCommon.h"

@interface TxServicesTester : XCTestCase

@end

@implementation TxServicesTester

- (void)setUp {
    
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)test_Query {  AsyncTestBegin(@"TxServices - Query");
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    [T.xuperClient.tx queryWithTXID:T.queryTxID handle:^(Transaction * _Nullable tx, NSError * _Nullable error) {
        
        XCTAssertNotNil(tx);
        XCTAssertNil(error);
        AsyncTestFulfill();
        
    }];
    
AsyncTestWaiting5S(); }

@end
