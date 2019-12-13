//
//  BlockServicesTester.m
//  xuper-sdk-oc-iOSTests
//
//  Created by apple on 2019/12/8.
//  Copyright © 2019 Martin.Ren. All rights reserved.
//

#import "TestCommon.h"

@interface BlockServicesTester : XCTestCase

@end

@implementation BlockServicesTester

- (void)setUp {
    
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)test_BlockWithID { AsyncTestBegin(@"BlockServices - GetBlockWithID");
 
    [T.xuperClient.block blockWithID:T.blockID needContent:YES handle:^(XBlock * _Nullable block, NSError * _Nullable error) {
        
        XCTAssertNotNil(block);
        XCTAssertNil(error);
        XCTAssert(block.blockid.length > 0);
        
        AsyncTestFulfill();
        
    }];
    
AsyncTestWaiting5S();}

- (void)test_BlockWithHeight { AsyncTestBegin(@"ACLServices - GetBlockWithHeight");
 
    [T.xuperClient.block blockWithHeight:1000 handle:^(XBlock * _Nullable block, NSError * _Nullable error) {
        
        XCTAssertNotNil(block);
        XCTAssertNil(error);
        XCTAssert(block.blockid.length > 0);
        
        AsyncTestFulfill();
        
    }];
    
AsyncTestWaiting5S();}

@end
