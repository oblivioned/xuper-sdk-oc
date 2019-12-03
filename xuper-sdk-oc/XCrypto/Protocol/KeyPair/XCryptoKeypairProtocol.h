//
//  XCryptoKeyPari.h
//  xuper-sdk-oc
//
//  Created by apple on 2019/12/2.
//  Copyright © 2019 Martin.Ren. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "XCryptoPubKeyProtocol.h"
#import "XCryptoPrivKeyProtocol.h"

@protocol XCryptoKeypairProtocol <NSObject>

- (id<XCryptoPubKeyProtocol> _Nonnull)publicKey;

- (id<XCryptoPrivKeyProtocol> _Nonnull)privateKey;

@end
