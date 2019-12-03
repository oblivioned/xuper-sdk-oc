//
//  XCryptoClientECC.m
//  xuper-sdk-oc
//
//  Created by apple on 2019/11/29.
//  Copyright © 2019 Martin.Ren. All rights reserved.
//


#import <openssl/bn.h>
#import <openssl/asn1.h>
#import <openssl/ecdsa.h>
#import <openssl/sha.h>

#import "NSData+xCodeable.h"

#import "XECDSAPubKey.h"
#import "XECDSAClient.h"
#import "XECDSAAccount.h"


@implementation XECDSAClient

/// 创建一个新的密钥
- (id<XCryptoAccountProtocol> _Nullable) generateKeyWithError:(NSError * _Nullable * _Nonnull)err {
    return [XECDSAAccount generatECDSAKey];
}

/// 使用私钥签名,签名前不会计算摘要
- (NSData * _Nullable) signRawMessage:(NSData * _Nonnull)rawmessage keypair:(id<XCryptoKeypairProtocol> _Nonnull)keypair error:(NSError * _Nullable * _Nonnull)err {

    if ( ![keypair isKindOfClass:[XECDSAAccount class]]) {
        *err = [NSError errorWithDomain:@"keypair is not a XECDSAKey object" code:-1 userInfo:nil];
        return nil;
    }

    id<UNSAFE_XCryptoPrivKeyProtocol> UNSAFE_keypair = (id<UNSAFE_XCryptoPrivKeyProtocol>)keypair.privateKey;
    
    const void *message = rawmessage.bytes;
    const EC_KEY *eckey256 = UNSAFE_keypair.UNSAFE_ec_private_key;
    
    ECDSA_SIG *ecdsa_sig = NULL;
    NSData *ret = NULL;
    
    unsigned long sig_len = ECDSA_size(eckey256);
    unsigned char *signature = NULL;
    unsigned char *asn1sig = (unsigned char *)malloc(sig_len);
    unsigned char *asnisig_ref = asn1sig;
    
    ecdsa_sig = ECDSA_do_sign(message, (int)rawmessage.length, (EC_KEY*)eckey256);
    if ( !ecdsa_sig ) {
        *err = [NSError errorWithDomain:@"ECDSA_do_sign failure." code:-1 userInfo:nil];
        goto ErrorReturn;
    }
    
    if ( !i2d_ECDSA_SIG(ecdsa_sig, &asnisig_ref)  ) {
        *err = [NSError errorWithDomain:@"i2d_ECDSA_SIG failure." code:-1 userInfo:nil];
        goto ErrorReturn;
    }
  
    ret = [NSData dataWithBytes:asn1sig length:sig_len];

ErrorReturn:

    ECDSA_SIG_free(ecdsa_sig);
    free(asn1sig); asn1sig = NULL;
    free(signature); signature = NULL;
    signature = NULL;
    
    return ret;
}

/// 使用ECC公钥来验证签名
- (BOOL) verifyWithPublicKey:(id<XCryptoPubKeyProtocol> _Nonnull)publickey signature:(XSignature _Nonnull)signature rawMessage:(NSData * _Nonnull)rawmessage error:(NSError * _Nullable * _Nonnull)err {
    
    if ( ![publickey isKindOfClass:[XECDSAPubKey class]]) {
        *err = [NSError errorWithDomain:@"keypair is not a XECDSAPubKey object" code:-1 userInfo:nil];
        return nil;
    }
    
    id<UNSAFE_XCryptoPubKeyProtocol> UNSAFE_pub_key = (id<UNSAFE_XCryptoPubKeyProtocol>)publickey;
    
    return ECDSA_verify(0, rawmessage.bytes, (int)rawmessage.length, signature.bytes, (int)signature.length, (EC_KEY*)UNSAFE_pub_key.UNSAFE_ec_public_key);
}


- (XAddress _Nullable) getAddressWithPublicKey:(id<XCryptoPubKeyProtocol> _Nonnull)publickey error:(NSError * _Nullable * _Nonnull)err {
    
    if ( ![publickey isKindOfClass:[XECDSAPubKey class]]) {
        *err = [NSError errorWithDomain:@"keypair is not a XECDSAPubKey object" code:-1 userInfo:nil];
        return nil;
    }
    
    return publickey.address;
}

/// 验证钱包地址是否是合法的格式。如果成功，返回true和对应的版本号；如果失败，返回false和默认的版本号0
- (BOOL) checkFormatWithAddress:(XAddress _Nonnull)address version:( unsigned int * _Nullable )version error:(NSError * _Nullable * _Nonnull)err {
    
    /// 地址一共25个字符
    /// [0] 版本
    /// [1 - 20] 源地址
    /// [21 - 24] 校验码
    const char *binAddress = [NSData xFromBase58String:address].bytes;
    
    /// 目前在使用的version如下
    /// 1 : CurveNist NIST
    /// 2 : CurveGm 国密
    /// 3 : NIST+Schnorr
    unsigned int v = (unsigned int)binAddress[0];
    if ( !(v > 0 && v < 3) ) {
        *version = 0;
        *err = [NSError errorWithDomain:@"this cryptography has not been supported yet." code:-1 userInfo:nil];
        return false;
    }
    else if ( version ) {
        *version = v;
    }
    
    /// 获取源地址
    unsigned char originAddress[21] = {0};
    memcpy(originAddress, binAddress, 21);
    
    /// 双重SHA256
    unsigned char hash[32] = {0};
    SHA256(originAddress, 21, hash);
    SHA256(hash, 32, hash);
    
    /// 使用二进制地址的后4位 （binAddress + 21） 和 双重hash的后4位对比，结果一致则说明地址格式正确
    if ( !memcmp(binAddress + 21, hash + (32 - 4), 4) ) {
        *err = [NSError errorWithDomain:@"invaild address." code:-1 userInfo:nil];
        return false;
    }
    
    return true;
}

/// 验证钱包地址是否和指定的公钥match。如果成功，返回true和对应的版本号；如果失败，返回false和默认的版本号0
- (BOOL) verifyUsingPublicKeyWithAddress:(XAddress _Nonnull)address publicKey:(id<XCryptoPubKeyProtocol> _Nonnull)publickey version:(uint8_t * _Nullable * _Nonnull)version error:(NSError * _Nullable * _Nonnull)err {
    return false;
}

@end
