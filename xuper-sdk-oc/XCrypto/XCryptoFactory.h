//
//  XCrypto.h
//  xuper-sdk-oc
//
//  Created by apple on 2019/11/29.
//  Copyright © 2019 Martin.Ren. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "XCommon.h"
#import "XCryptoClientProtocol.h"

XSDKExtern XCryptoTypeStringKey const _Nonnull XCryptoTypeStringKeyDefault;
XSDKExtern XCryptoTypeStringKey const _Nonnull XCryptoTypeStringKeyECC;

@interface XCryptoFactory : NSObject

+ (id<XCryptoClientProtocol> _Nullable) cryptoClientWithCryptoType:(XCryptoTypeStringKey _Nonnull)cryptoType;

@end
