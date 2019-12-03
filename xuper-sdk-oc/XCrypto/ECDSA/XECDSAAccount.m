//
//  XECDSAAccount.m
//  xuper-sdk-oc
//
//  Created by apple on 2019/11/30.
//  Copyright © 2019 Martin.Ren. All rights reserved.
//

#import "XECDSAAccount.h"

#import <openssl/objects.h>
#import <openssl/ec.h>
#import <openssl/bn.h>
#import <openssl/sha.h>
#import <openssl/ripemd.h>

#import "XECDSAPubKey.h"
#import "XECDSAPrivKey.h"

#import "NSData+xCodeable.h"

@interface XECDSAAccount() {
    
    XECDSAPubKey *_pub_Key;
    
    XECDSAPrivKey *_priv_Key;
}

@end

@implementation XECDSAAccount

+ (instancetype _Nullable) generatECDSAKey {
    
    XECDSAPrivKey *newPrivKey = [XECDSAPrivKey generateKey];
    
    return [[XECDSAAccount alloc] initWithPrivateKey:newPrivKey];
}

+ (instancetype _Nullable) fromPrivateKey:(id<XCryptoPrivKeyProtocol> _Nonnull)privKey {
    
    if ( ![privKey isKindOfClass:[XECDSAPrivKey class]]) {
        return nil;
    }
    
    return [[XECDSAAccount alloc] initWithPrivateKey:(XECDSAPrivKey*)privKey];
}

- (instancetype _Nullable) initWithPrivateKey:(XECDSAPrivKey * _Nonnull)p {
    
    self = [super init];
    
    self->_priv_Key = p;
    self->_pub_Key = (XECDSAPubKey*)p.publicKey;
    
    return self;
}


- (XAddress _Nullable)address {
    return self->_pub_Key.address;
}

- (NSData * _Nullable)entropyByte {
    return nil;
}

- (NSString * _Nullable)mnemonic {
    return @"";
}

- (XJsonString _Nullable)jsonPrivateKey {
    return self->_priv_Key.jsonFormatString;
}

- (XJsonString _Nullable)jsonPublicKey {
   return self->_pub_Key.jsonFormatString;
}

- (id<XCryptoPrivKeyProtocol> _Nonnull)privateKey {
    return self->_priv_Key;
}

- (id<XCryptoPubKeyProtocol> _Nonnull)publicKey {
    return self->_pub_Key;
}


@end
