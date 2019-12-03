//
//  XCrypto.m
//  xuper-sdk-oc
//
//  Created by apple on 2019/11/29.
//  Copyright © 2019 Martin.Ren. All rights reserved.
//

#import "XCryptoFactory.h"

XSDKEnumCryptoTypeStringKey const XSDKEnumCryptoTypeStringKeyECC = @"ECC";

@implementation XCryptoFactory

+ (id<XCryptoClientProtocol>) cryptoClientWithCryptoType:(XSDKEnumCryptoTypeStringKey)cryptoType {
    return nil;
}

@end
