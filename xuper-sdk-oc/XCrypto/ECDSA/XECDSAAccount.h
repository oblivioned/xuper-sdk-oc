//
//  XECDSAAccount.h
//  xuper-sdk-oc
//
//  Created by apple on 2019/11/30.
//  Copyright © 2019 Martin.Ren. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "XCryptoAccountProtocol.h"
#import "XCryptoKeypairProtocol.h"

#import "XECDSAPrivKey.h"

@interface XECDSAAccount : NSObject <XCryptoKeypairProtocol, XCryptoAccountProtocol>

+ (instancetype _Nullable) generatECDSAKey;

+ (instancetype _Nullable) fromPrivateKey:(id<XCryptoPrivKeyProtocol> _Nonnull)privKey;

- (instancetype _Nullable) initWithPrivateKey:(XECDSAPrivKey * _Nonnull)p;

@end



