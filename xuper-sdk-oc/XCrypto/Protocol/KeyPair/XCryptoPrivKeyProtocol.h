//
//  XCryptoPrivKey.h
//  xuper-sdk-oc
//
//  Created by apple on 2019/12/2.
//  Copyright © 2019 Martin.Ren. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <openssl/ec.h>

@protocol UNSAFE_XCryptoPrivKeyProtocol <NSObject>

- (EC_KEY * _Nonnull) UNSAFE_ec_private_key;

@end

@protocol XCryptoPrivKeyProtocol <NSObject>

- (XJsonString _Nonnull) jsonFormatString;

@end

