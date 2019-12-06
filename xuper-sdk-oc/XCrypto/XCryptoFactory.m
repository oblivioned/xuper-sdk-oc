//
//  XCrypto.m
//  xuper-sdk-oc
//
//  Created by apple on 2019/11/29.
//  Copyright © 2019 Martin.Ren. All rights reserved.
//

#import "XCryptoFactory.h"
#import "XECDSAClient.h"

XSDKEnumCryptoTypeStringKey const XSDKEnumCryptoTypeStringKeyECC = @"ECDSA";

XSDKEnumCryptoTypeStringKey const XSDKEnumCryptoTypeStringKeyDefault = XSDKEnumCryptoTypeStringKeyECC;

@implementation XCryptoFactory

+ (id<XCryptoClientProtocol>) cryptoClientWithCryptoType:(XSDKEnumCryptoTypeStringKey)cryptoType {
    
    if ( cryptoType == XSDKEnumCryptoTypeStringKeyECC ) {
        return [[XECDSAClient alloc] init];
    }
    
    NSAssert(false, @"unsupported crypto type.");
    return nil;
}

@end
