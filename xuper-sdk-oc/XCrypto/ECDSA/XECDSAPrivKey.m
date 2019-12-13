//
//  XECDSAPrivKey.m
//  xuper-sdk-oc
//
//  Created by apple on 2019/12/2.
//  Copyright © 2019 Martin.Ren. All rights reserved.
//

#import <openssl/bn.h>
#import <openssl/ec.h>
#import <openssl/objects.h>

#import "XECDSAPrivKey.h"
#import "XECDSAPubKey.h"

#define XJsonPrivateKeyFormat (@"{\"Curvname\":\"%@\",\"X\":%@,\"Y\":%@,\"D\":%@}")
#define XJsonPrivateSerialize(C, X, Y, D) ([NSString stringWithFormat:XJsonPrivateKeyFormat, (C), (X), (Y), (D)])

@interface XECDSAPrivKey() <UNSAFE_XCryptoPrivKeyProtocol> {
    
    /// c
    EC_KEY *_ec_key;
    
    BN_CTX *_bn_ctx;
    
    BIGNUM *_x;
    BIGNUM *_y;
    
    const BIGNUM *_d;
    
    const EC_POINT *_ec_pub_key;
    const EC_GROUP *_ec_group;
    
    /// objective-c
    XECDSAPubKey * pubKey;
}

@end

@implementation XECDSAPrivKey

+ (instancetype _Nullable) fromExportedJsonContent:(NSData* _Nonnull)keydata {
    
    NSError *err;
    NSDictionary *r = [NSJSONSerialization JSONObjectWithData:keydata options:0 error:&err];
    
    if ( err || r == NULL || [r isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    
    return [XECDSAPrivKey fromExportedDictionary:r];
}

+ (instancetype _Nullable) fromExportedDictionary:(NSDictionary* _Nonnull)keydict {
    return [[XECDSAPrivKey alloc] initWithDictionary:keydict];
}

+ (instancetype _Nullable) generateKey {
    
    EC_KEY *eckey256 = EC_KEY_new_by_curve_name( NID_X9_62_prime256v1 );
    if ( eckey256 == NULL ) {
        EC_KEY_free(eckey256);
        return nil;
    }
    
    if ( !EC_KEY_generate_key(eckey256) ) {
        EC_KEY_free(eckey256);
        return nil;
    }
    
    XECDSAPrivKey *pk = [[XECDSAPrivKey alloc] initWithECKey:eckey256];
    
    EC_KEY_free(eckey256);
    
    return pk;
}

- (instancetype _Nullable) initWithDictionary:(NSDictionary<NSString*, NSString*> * _Nonnull)keydict {
    
    self = [super init];
    
    NSSet *originSets = [[NSSet alloc] initWithArray:keydict.allKeys];
    NSSet *parmasSets = [[NSSet alloc] initWithArray:@[
        @"Curvname", @"X", @"Y", @"D"
    ]];
    
    /// 缺少必要参数
    if ( ![originSets isEqualToSet:parmasSets] ) {
        return nil;
    }
    
    /// 不是对应的私钥格式
    if ( ![keydict[@"Curvname"] isEqualToString:@"P-256"] ) {
        return nil;
    }
    
    /// malloc
    self->_ec_key = EC_KEY_new_by_curve_name( NID_X9_62_prime256v1 );
    self->_bn_ctx = BN_CTX_new();
    self->_x = BN_new();
    self->_y = BN_new();
    
    /// init
    self->_ec_group = EC_KEY_get0_group(self->_ec_key);
    
    /// memory objects
    BIGNUM *mem_d = BN_new();
    
    if ( !BN_dec2bn(&mem_d, keydict[@"D"].UTF8String ) ) {
        BN_free(mem_d);
        return nil;
    }
    
    if ( !BN_dec2bn(&(self->_x), keydict[@"X"].UTF8String ) ) {
        BN_free(mem_d);
        return nil;
    }
    
    if ( !BN_dec2bn(&(self->_y), keydict[@"Y"].UTF8String ) ) {
        BN_free(mem_d);
        return nil;
    }
    
    if ( !EC_KEY_set_private_key(self->_ec_key, mem_d) ) {
        BN_free(mem_d);
        return nil;
    }
    
    BN_clear_free(mem_d); mem_d = NULL;
    
    if ( !EC_KEY_set_public_key_affine_coordinates(self->_ec_key, self->_x, self->_y) ) {
        return nil;
    }
    
    /// 重新获取EC_KEY结构中的pubkey 和 D，虽然mem_d就是私钥，但是在EC_KEY_set_private_key，EC_KEY结构会复制一份，此处没必要保存两份D
    self->_ec_pub_key = EC_KEY_get0_public_key(self->_ec_key);
    self->_d = EC_KEY_get0_private_key(self->_ec_key);
    
    self->pubKey = [[XECDSAPubKey alloc] initWithECGroup:self->_ec_group ecPoint:self->_ec_pub_key];
    
    return self;
}

- (instancetype _Nullable) initWithECKey:( const EC_KEY * _Nonnull )ecKey {
    
    self = [super init];
    
    self->_bn_ctx = BN_CTX_new();
    self->_ec_key = EC_KEY_new();
    self->_x = BN_new();
    self->_y = BN_new();
    
    self->_ec_key = EC_KEY_dup(ecKey);
    
    self->_ec_group = EC_KEY_get0_group(self->_ec_key);
    self->_d = EC_KEY_get0_private_key(self->_ec_key);
    self->_ec_pub_key = EC_KEY_get0_public_key(self->_ec_key);
    
    if ( !EC_POINT_get_affine_coordinates_GFp(self->_ec_group, self->_ec_pub_key, self->_x, self->_y, self->_bn_ctx) ) {
        return nil;
    }
    
    /// 创建公钥
    self->pubKey = [[XECDSAPubKey alloc] initWithECGroup:self->_ec_group ecPoint:self->_ec_pub_key];
    
    return self;
}

- (void) dealloc {
    
    BN_free(self->_x);
    BN_free(self->_y);
    BN_CTX_free(self->_bn_ctx);
    EC_KEY_free(self->_ec_key);
}

- (id<XCryptoPubKeyProtocol> _Nonnull) publicKey {
    return self->pubKey;
}

- (XJsonString) jsonFormatString {
    return XJsonPrivateSerialize(@"P-256",
                                 [NSString stringWithUTF8String:BN_bn2dec(self->_x)],
                                 [NSString stringWithUTF8String:BN_bn2dec(self->_y)],
                                 [NSString stringWithUTF8String:BN_bn2dec(self->_d)]);
}

#pragma mark -- UNSAFE_XCryptoPrivKeyProtocol
- (EC_KEY * _Nonnull) UNSAFE_ec_private_key {
    return self->_ec_key;
}

@end
