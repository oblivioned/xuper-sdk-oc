//
//  TestCommon.c
//  xuper-sdk-oc
//
//  Created by apple on 2019/12/4.
//  Copyright © 2019 Martin.Ren. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <xuper_sdk_oc/xuper_sdk_oc.h>

#define AsyncTestBegin(__desc) XCTestExpectation *___expectation = [self expectationWithDescription:__desc]
#define AsyncTestWaiting(__time) [self waitForExpectationsWithTimeout:__time handler:^(NSError * _Nullable error) { \
    if (error) {\
        XCTFail(@"Async Test %@ time out with error %@", ___expectation.description, error);\
    }\
}]

#define AsyncTestWaiting3S() AsyncTestWaiting(3)
#define AsyncTestWaiting5S() AsyncTestWaiting(5)
#define AsyncTestFulfill() [___expectation fulfill]

@interface T : NSObject

+ (XuperClient *) xuperClient;

+ (XECDSAAccount *) initor;

+ (XECDSAAccount *) initor2;

+ (XAddress) toAddress;

+ (XAccount) account;

+ (XHexString) blockID;

+ (XHexString) queryTxID;
@end
