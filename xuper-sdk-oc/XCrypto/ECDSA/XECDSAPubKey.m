//
//  XECDSAPubKey.m
//  xuper-sdk-oc
//
//  Created by apple on 2019/12/2.
//  Copyright © 2019 Martin.Ren. All rights reserved.
//

#import "XECDSAPubKey.h"

#import <openssl/sha.h>
#import <openssl/ripemd.h>
#import <openssl/ec.h>
#import <openssl/objects.h>

#import "NSData+xCodeable.h"

#define XJsonPublicKeyFormat (@"{\"Curvname\":\"%@\",\"X\":%@,\"Y\":%@}")
#define XJsonPublicKeySerialize(C, X, Y) ([NSString stringWithFormat:XJsonPublicKeyFormat, (C), (X), (Y)])

@interface XECDSAPubKey() <UNSAFE_XCryptoPubKeyProtocol> {
    
    EC_KEY *_ec_key;
    BN_CTX *_bn_ctx;
    
    BIGNUM *_x;
    BIGNUM *_y;
    
    const EC_GROUP *_group;
    
    XAddress _address;
}

@end

@implementation XECDSAPubKey

- (instancetype _Nonnull) init {
    
    self = [super init];
    
    self->_ec_key = EC_KEY_new();
    self->_bn_ctx = BN_CTX_new();
    self->_x = BN_new();
    self->_y = BN_new();
    
    return self;
}

- (instancetype _Nullable) initWithJsonFormatString:(NSString *)ppjson error:(NSError * _Nonnull * _Nullable)error {
    
    if ( [ppjson rangeOfString:@"P-256"].location == NSNotFound ) {
        return nil;
    }
    
    NSString *xpattern = @"\\\"[a-zA-Z]\\\"\\:[\\d]*";

    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:xpattern options:0 error:nil];

    NSArray *matches = [regex matchesInString:ppjson options:0 range:NSMakeRange(0, ppjson.length)];
    
    if (matches.count != 2) {
        return nil;
    }

    NSString *xstring = @"";
    NSString *ystring = @"";
    
    for (NSTextCheckingResult* match in matches) {
        
        NSString *rangeString = [ppjson substringWithRange:match.range];
        
        NSArray<NSString*> *split = [rangeString componentsSeparatedByString:@":"];
        
        if ( [split[0] isEqualToString:@"\"X\""] ) {
            xstring = split[1];
        } else if ( [split[0] isEqualToString:@"\"Y\""] ) {
            ystring = split[1];
        }
    }
    
    return [self initWithXString:xstring yString:ystring error:error];
}

- (instancetype _Nullable) initWithXString:(NSString * _Nonnull)x yString:(NSString * _Nonnull)y error:(NSError * _Nonnull * _Nullable)error {
    
    self = [super init];
    
    /// malloc
    self->_ec_key = EC_KEY_new_by_curve_name( NID_X9_62_prime256v1 );
    self->_bn_ctx = BN_CTX_new();
    self->_x = BN_new();
    self->_y = BN_new();
    
    /// init
    self->_group = EC_KEY_get0_group(self->_ec_key);
    
    if ( !BN_dec2bn(&(self->_x), x.UTF8String ) ) {
        return nil;
    }
    
    if ( !BN_dec2bn(&(self->_y), y.UTF8String ) ) {
        return nil;
    }
    
    return self;
}

- (instancetype _Nullable) initWithECGroup:(const EC_GROUP * _Nonnull)g rawPublicKey:(NSData * _Nonnull)pp {
    
    self = [self init];
    
    self->_group = g;
    
    if ( !EC_KEY_set_group(self->_ec_key, self->_group) ) {
        return nil;
    }
    
    const unsigned char * ppbin = pp.bytes;
    
    o2i_ECPublicKey(&self->_ec_key, (const unsigned char **)&ppbin, pp.length);
    
    const EC_POINT *p = EC_KEY_get0_public_key(self->_ec_key);
    
    if ( !EC_POINT_get_affine_coordinates_GFp(self->_group, p, self->_x, self->_y, self->_bn_ctx) ) {
        return nil;
    }
    
    return self;
}

- (instancetype _Nullable) initWithECGroup:(const EC_GROUP * _Nonnull)g ecPoint:(const EC_POINT * _Nonnull)p {
    
    self = [self init];
    
    self->_group = g;
    if ( !EC_KEY_set_group(self->_ec_key, self->_group) ) {
        return nil;
    }
    
    if ( !EC_KEY_set_public_key(self->_ec_key, p) ) {
        return nil;
    }
    
    if ( !EC_POINT_get_affine_coordinates_GFp(self->_group, p, self->_x, self->_y, self->_bn_ctx) ) {
        return nil;
    }
    
    return self;
}

- (void) dealloc {
    
    BN_free(self->_x);
    BN_free(self->_y);
    BN_CTX_free(self->_bn_ctx);
}

- (XJsonString) jsonFormatString {
    return XJsonPublicKeySerialize(@"P-256", [NSString stringWithUTF8String:BN_bn2dec(self->_x)], [NSString stringWithUTF8String:BN_bn2dec(self->_y)]);
}

- (XAddress _Nullable) address {
    
    if ( !_address ) {
        
        unsigned int byteLen = (256 + 7) >> 3;
        unsigned char *xbytes = (unsigned char *)malloc(byteLen);
        unsigned char *ybytes = (unsigned char *)malloc(byteLen);
        unsigned char *marshalBytes = (unsigned char *)malloc( 1 + 2 * byteLen);
        unsigned char marshalSHA256[32] = {0};
        unsigned char marshalRIPEMD160[20] = {0};
        unsigned char marshalAddress[21] = {0};
        unsigned char marshalAddressDoubleSHA256[32] = {0};
        unsigned char base58Slice[25] = {0}; //0-19:RIPEMD160 20-23:simpleCheckCode(双重SHA256的前四子节，应该是作为一个校验码)
        NSData *base58SliceData = NULL;
        
        /// 1. Marshal Data
        marshalBytes[0] = 4;
        
        if ( !BN_bn2bin(self->_x, xbytes) ) {
            goto ErrorReturn;
        }
        
        if ( !BN_bn2bin(self->_y, ybytes) ) {
            goto ErrorReturn;
        }
        
        memcpy(marshalBytes + 1, xbytes, byteLen);
        memcpy(marshalBytes + 1 + byteLen, ybytes, byteLen);
        
        /// 2. SHA256
        if ( SHA256(marshalBytes, 1 + 2 * byteLen, marshalSHA256) == NULL ) {
            goto ErrorReturn;
        }
        
        /// 3.Ripemd160
        if ( RIPEMD160(marshalSHA256, 32, marshalRIPEMD160) == NULL ) {
            goto ErrorReturn;
        }
        
        /// 4.在头部写入地址版本
        /// CurveNist/CurveGm : 2 default
        /// CurveNistSN: 3
        marshalAddress[0] = 1;
        memcpy(marshalAddress + 1, marshalRIPEMD160, 20);
        
        /// 5.双重SHA256
        SHA256(marshalAddress, 21, marshalAddressDoubleSHA256);
        SHA256(marshalAddressDoubleSHA256, 32, marshalAddressDoubleSHA256);
        
        memcpy(base58Slice, marshalAddress, 21);
        memcpy(base58Slice + 21, marshalAddressDoubleSHA256, 4);
        
        /// 6.转换为NSData
        base58SliceData = [NSData dataWithBytes:base58Slice length:25];
        
        _address = base58SliceData.xBase58String;
                              
    ErrorReturn:
        
        free(marshalBytes);marshalBytes = NULL;
        free(ybytes);ybytes = NULL;
        free(xbytes);ybytes = NULL;
    }
    
    return _address;
}

#pragma mark -- UNSAFE_XCryptoPubKeyProtocol


- (const EC_GROUP * _Nonnull)UNSAFE_ec_group {
    return self->_group;
}

- (const BIGNUM * _Nonnull)UNSAFE_x {
    return self->_x;
}

- (const BIGNUM * _Nonnull)UNSAFE_y {
    return self->_y;
}

- (const EC_KEY * _Nonnull)UNSAFE_ec_public_key {
    return self->_ec_key;
}

@end
