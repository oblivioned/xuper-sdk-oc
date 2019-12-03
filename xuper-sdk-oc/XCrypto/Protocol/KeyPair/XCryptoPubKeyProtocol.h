//
//  XCryptoPubKey.h
//  xuper-sdk-oc
//
//  Created by apple on 2019/12/2.
//  Copyright © 2019 Martin.Ren. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <openssl/bn.h>
#import <openssl/ec.h>

@protocol UNSAFE_XCryptoPubKeyProtocol <NSObject>

- (const BIGNUM * _Nonnull) UNSAFE_x;
- (const BIGNUM * _Nonnull) UNSAFE_y;
- (const EC_GROUP * _Nonnull) UNSAFE_ec_group;
- (const EC_KEY * _Nonnull) UNSAFE_ec_public_key;

@end

@protocol XCryptoPubKeyProtocol <NSObject>

- (XAddress _Nullable) address;

- (XJsonString _Nonnull) jsonFormatString;

@end
