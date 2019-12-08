//
//  XCrypto.m
//  xuper-sdk-oc
//
//  Created by apple on 2019/11/29.
//  Copyright © 2019 Martin.Ren. All rights reserved.
//

#import "XCryptoFactory.h"
#import "XECDSAClient.h"

XCryptoTypeStringKey const XCryptoTypeStringKeyECC = @"ECDSA";

XCryptoTypeStringKey const XCryptoTypeStringKeyDefault = XCryptoTypeStringKeyECC;

@implementation XCryptoFactory

+ (id<XCryptoClientProtocol>) cryptoClientWithCryptoType:(XCryptoTypeStringKey)cryptoType {
    
    if ( cryptoType == XCryptoTypeStringKeyECC ) {
        return [[XECDSAClient alloc] init];
    }
    
    NSAssert(false, @"unsupported crypto type.");
    return nil;
}

@end
