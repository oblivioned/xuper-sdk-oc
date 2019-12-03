//
//  XECDSAPubKey.h
//  xuper-sdk-oc
//
//  Created by apple on 2019/12/2.
//  Copyright © 2019 Martin.Ren. All rights reserved.
//

#import <openssl/ec.h>
#import <openssl/bn.h>

#import "XCommon.h"
#import "XCryptoPubKeyProtocol.h"

@interface XECDSAPubKey : NSObject <XCryptoPubKeyProtocol>

- (instancetype _Nullable) initWithECGroup:(const EC_GROUP * _Nonnull)g ecPoint:(const EC_POINT * _Nonnull)p;

- (instancetype _Nullable) initWithECGroup:(const EC_GROUP * _Nonnull)g rawPublicKey:(NSData * _Nonnull)pp;

@end
