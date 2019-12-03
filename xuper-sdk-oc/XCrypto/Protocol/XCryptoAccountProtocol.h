//
//  XCryptoKeyProtocol.h
//  xuper-sdk-oc
//
//  Created by apple on 2019/11/30.
//  Copyright © 2019 Martin.Ren. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "XCommon.h"
#import "XCryptoKeypairProtocol.h"


@protocol XCryptoKeyInfo <NSObject>

- (NSData * _Nullable) entropyByte;

- (NSString * _Nullable) mnemonic;

- (XAddress _Nullable) address;

@end


@protocol XCryptoAccountProtocol <XCryptoKeyInfo, XCryptoKeypairProtocol>

- (XJsonString _Nullable) jsonPrivateKey;

- (XJsonString _Nullable) jsonPublicKey;

@end


