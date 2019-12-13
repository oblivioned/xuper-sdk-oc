//
//  TestACLServices.m
//  xuper-sdk-oc-iOSTests
//
//  Created by apple on 2019/12/8.
//  Copyright © 2019 Martin.Ren. All rights reserved.
//

#import "TestCommon.h"

@interface ACLServicesTester : XCTestCase

@end

@implementation ACLServicesTester

- (void)setUp {
    
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)test_QueryACL { AsyncTestBegin(@"ACLServices - QueryACL");
 
    [T.xuperClient.acl queryWithAccount:T.account handle:^(XTransactionACL * _Nullable acl, NSError * _Nullable error) {
         
        XCTAssertNotNil(acl);
        XCTAssertNil(error);
        AsyncTestFulfill();
        
    }];
    
AsyncTestWaiting5S();}

@end
