//
//  WasmServicesTester.m
//  xuper-sdk-oc-iOSTests
//
//  Created by apple on 2019/12/11.
//  Copyright © 2019 Martin.Ren. All rights reserved.
//

#import "TestCommon.h"

@interface WasmServicesTester : XCTestCase

@end

@implementation WasmServicesTester

- (void)setUp {
  
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)test_Query { AsyncTestBegin(@"WasmServices - Query");

    [T.xuperClient.wasm queryWithAddress:T.initor.address
                           authRequires:@[T.initor.address]
                           contractName:@"ERC20"
                             methodName:@"balance"
                                   args:@{@"caller" : @"Martin"}
                                 handle:^(InvokeResponse * _Nullable response, NSError * _Nullable error) {
        
        XCTAssertNotNil(response);
        XCTAssertNil(error);
        AsyncTestFulfill();
        
    }];
    
AsyncTestWaiting5S(); }


- (void) test_Invoke {  AsyncTestBegin(@"WasmServices - Invoke");
        
    [T.xuperClient.wasm invokeWithAddress:T.initor.address
                             authRequires:@[T.initor.address]
                             contractName:@"ERC20"
                               methodName:@"transfer"
                                     args:@{
                                         @"from"    : @"Martin",
                                         @"to"      : @"Bob",
                                         @"token"   : @"10"
                                     }
                             forzenHeight:0
                            initorKeypair:T.initor
                      authRequireKeypairs:@[T.initor]
                                 feeAsker:nil
                                   handle:^(XHexString  _Nullable txhash, NSError * _Nullable error) {
    
        XCTAssertNotNil(txhash);
        XCTAssertNil(error);
        AsyncTestFulfill();
        
        NSLog(@"TxID:%@", txhash);
        
    }];
    
AsyncTestWaiting5S(); }


@end
