//
//  NSData+HexString.m
//  xuper-sdk-oc
//
//  Created by apple on 2019/11/29.
//  Copyright © 2019 Martin.Ren. All rights reserved.
//

#import "NSData+xCodeable.h"

#import <openssl/bn.h>
#import <openssl/sha.h>
#import <openssl/evp.h>
#import <openssl/objects.h>

const char * const BASE58TABLE = "123456789ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz";

const char ALPHABET_MAP[128] = {
    -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
    -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
    -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
    -1,  0,  1,  2,  3,  4,  5,  6,  7,  8, -1, -1, -1, -1, -1, -1,
    -1,  9, 10, 11, 12, 13, 14, 15, 16, -1, 17, 18, 19, 20, 21, -1,
    22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, -1, -1, -1, -1, -1,
    -1, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, -1, 44, 45, 46,
    47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, -1, -1, -1, -1, -1
};

@implementation NSData(xCodeable)

- (NSString * _Nonnull ) xBigNumberString {
    
    if (self.length <= 0) {
        return @"0";
    }
    
    BIGNUM *num = BN_new();
    
    BN_bin2bn(self.bytes, (int)self.length, num);
    
    char *hex = BN_bn2dec(num);
    
    NSString *ret = [[NSString alloc] initWithUTF8String:hex];

    OPENSSL_free(hex);
    
    BN_free(num);
    
    return ret;
}

- (NSString * _Nonnull) xHexString {
    
    if (self.length <= 0) {
        return @"";
    }
    
    BIGNUM *num = BN_new();
    
    BN_bin2bn(self.bytes, (int)self.length, num);
    
    char *hex = BN_bn2hex(num);
    
    NSString *ret = [[NSString alloc] initWithUTF8String:hex];

    OPENSSL_free(hex);
    
    BN_free(num);
    
    return ret.lowercaseString;
}

- (NSData * _Nonnull ) xBase64Data {
    return [self.xBase64String dataUsingEncoding:NSUTF8StringEncoding];
}

- (NSString * _Nonnull ) xBase64String {
    return [self base64EncodedStringWithOptions:0];
}

- (NSString * _Nonnull ) xBase58String {

    NSMutableData *ret = [[NSMutableData alloc] init];

    BN_CTX * bnctx  = BN_CTX_new();
    BIGNUM * bn     = BN_new();
    BIGNUM * bn0    = BN_new();
    BIGNUM * bn58   = BN_new();
    BIGNUM * dv     = BN_new();
    BIGNUM * rem    = BN_new();

    BN_bin2bn(self.bytes, (int)self.length, bn);
    BN_hex2bn(&bn58, "3a");//58
    BN_hex2bn(&bn0,"0");

    while( BN_cmp(bn, bn0) > 0) {

        BN_div(dv, rem, bn, bn58, bnctx);

        BN_copy(bn, dv);

        char base58char = BASE58TABLE[BN_get_word(rem)];

        [ret appendBytes:&base58char length:1];
    }

    NSUInteger pbegin = 0;
    NSUInteger pend = ret.length;

    while( pbegin < pend ) {

        char c = ((char*)ret.bytes)[pbegin];

        [ret replaceBytesInRange:NSMakeRange(pbegin, 1) withBytes:&((char*)ret.bytes)[--pend] length:1];
        pbegin++;

        [ret replaceBytesInRange:NSMakeRange(pend, 1) withBytes:&c length:1];
    }

    BN_clear_free(rem);
    BN_clear_free(dv);
    BN_clear_free(bn58);
    BN_clear_free(bn0);
    BN_clear_free(bn);
    BN_CTX_free(bnctx);

    return [[NSString alloc] initWithData:ret encoding:NSUTF8StringEncoding];
}

- (NSString * _Nonnull ) xJsonString {
    return [[NSString alloc] initWithData:self encoding:NSUTF8StringEncoding];
}

- (NSData * _Nullable ) xSHA256Data {
    
    NSData *hash = nil;
    
    EVP_MD_CTX *mctx = EVP_MD_CTX_create();
    
    const EVP_MD *md = EVP_sha256();
    unsigned char digest[EVP_MAX_MD_SIZE] = {0};
    unsigned int digest_len = 0;
    
    /// 1.求取摘要
    if (!mctx) {
        goto ErrorReturn;
    }

    EVP_MD_CTX_init(mctx);

    if ( !EVP_DigestInit(mctx, md) ) {
        goto ErrorReturn;
    }

    if ( !EVP_DigestUpdate(mctx, self.bytes, self.length) ) {
        goto ErrorReturn;
    }

    if ( !EVP_DigestFinal_ex(mctx, digest, &digest_len) ) {
        goto ErrorReturn;
    }
    
    hash = [NSData dataWithBytes:digest length:digest_len];
    
ErrorReturn:
    
    EVP_MD_CTX_destroy(mctx);
    
    return hash;
}

- (NSString * _Nullable ) xSHA256HexString {
    
    NSData *hashData = self.xSHA256Data;
    
    if ( !hashData ) {
        return nil;
    }
    
    BIGNUM *hashNumber = BN_new();
    
    if ( !BN_bin2bn(hashData.bytes, (int)hashData.length, hashNumber) ) {
        BN_clear_free(hashNumber);
        return nil;
    }
    
    char *hex = BN_bn2hex(hashNumber);
    
    NSString *ret = [[NSString alloc] initWithUTF8String:hex];
    
    BN_clear_free(hashNumber);
    
    OPENSSL_free(hex);
    
    return ret;
}

+ (NSData * _Nullable) xFromBase58String:(NSString*)base58string {
    
    int len = (int)base58string.length;
    unsigned char *result = malloc(len * 2);
    const unsigned char *str = [base58string dataUsingEncoding:NSUTF8StringEncoding].bytes;
    
    int resultlen = 1;
    for (int i = 0; i < len; i++) {
        unsigned int carry = (unsigned int) ALPHABET_MAP[str[i]];
        for (int j = 0; j < resultlen; j++) {
            carry += (unsigned int) (result[j]) * 58;
            result[j] = (unsigned char) (carry & 0xff);
            carry >>= 8;
        }
        while (carry > 0) {
            result[resultlen++] = (unsigned int) (carry & 0xff);
            carry >>= 8;
        }
    }

    for (int i = 0; i < len && str[i] == '1'; i++)
        result[resultlen++] = 0;

    // Poorly coded, but guaranteed to work.
    for (int i = resultlen - 1, z = (resultlen >> 1) + (resultlen & 1);
        i >= z; i--) {
        int k = result[i];
        result[i] = result[resultlen - i - 1];
        result[resultlen - i - 1] = k;
    }
    
    return [NSData dataWithBytes:result length:resultlen];
}

+ (NSData * _Nullable) xFromBase64String:(NSString * _Nonnull)base64string {
    return [[NSData alloc] initWithBase64EncodedString:base64string options:0];
}

+ (NSData * _Nullable) xFromHexString:(NSString * _Nonnull)base58string {
    
    if (base58string.length <= 0) {
        return nil;
    }
       
    BIGNUM *num = BN_new();
    
    BN_hex2bn(&num, base58string.UTF8String);

    int len = BN_num_bytes(num);
    
    unsigned char * bytes = malloc(len);
    
    if ( !BN_bn2bin(num, bytes) ) {
        BN_free(num);
        free(bytes); bytes = NULL;
        return nil;
    }
       
    NSData *ret = [[NSData alloc] initWithBytes:bytes length:len];
    
    BN_free(num);
    free(bytes); bytes = NULL;
    
    return ret;
}

- (NSString * _Nonnull ) xString {
    
    return [[NSString alloc] initWithData:self encoding:NSUTF8StringEncoding];
}

@end
