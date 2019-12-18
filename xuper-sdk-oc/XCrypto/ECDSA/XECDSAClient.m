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
#import <openssl/hmac.h>
#import <openssl/evp.h>

#import "NSData+xCodeable.h"

#import "XECDSAPubKey.h"
#import "XECDSAClient.h"
#import "XECDSAAccount.h"
#import "XECDSAPrivKey.h"
#import "XECDSABIP39Account.h"
#import "BIP39.h"

@implementation XECDSAClient

/// 创建一个新的密钥
- (id<XCryptoAccountProtocol> _Nullable) generateKey {
    return [XECDSAAccount generatECDSAKey];
}

/// 使用私钥签名,签名前不会计算摘要
- (NSData * _Nullable) signRawMessage:(NSData * _Nonnull)rawmessage keypair:(id<XCryptoKeypairProtocol> _Nonnull)keypair error:(NSError * _Nonnull * _Nullable)error {

    if ( ![keypair isKindOfClass:[XECDSAAccount class]]) {
        if (error) *error = [NSError errorWithDomain:@"keypair is not a XECDSAKey object" code:-1 userInfo:nil];
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
        if (error) *error = [NSError errorWithDomain:@"ECDSA_do_sign failure." code:-1 userInfo:nil];
        goto ErrorReturn;
    }
    
    if ( !i2d_ECDSA_SIG(ecdsa_sig, &asnisig_ref)  ) {
        if (error) *error = [NSError errorWithDomain:@"i2d_ECDSA_SIG failure." code:-1 userInfo:nil];
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
- (BOOL) verifyWithPublicKey:(id<XCryptoPubKeyProtocol> _Nonnull)publickey signature:(XSignature _Nonnull)signature rawMessage:(NSData * _Nonnull)rawmessage error:(NSError * _Nonnull * _Nullable)error {
    
    if ( ![publickey isKindOfClass:[XECDSAPubKey class]]) {
        if (error) *error = [NSError errorWithDomain:@"keypair is not a XECDSAPubKey object" code:-1 userInfo:nil];
        return nil;
    }
    
    id<UNSAFE_XCryptoPubKeyProtocol> UNSAFE_pub_key = (id<UNSAFE_XCryptoPubKeyProtocol>)publickey;
    
    return ECDSA_verify(0, rawmessage.bytes, (int)rawmessage.length, signature.bytes, (int)signature.length, (EC_KEY*)UNSAFE_pub_key.UNSAFE_ec_public_key);
}

- (XAddress _Nullable) getAddressWithPublicKey:(id<XCryptoPubKeyProtocol> _Nonnull)publickey error:(NSError * _Nonnull * _Nullable)error {
    
    if ( ![publickey isKindOfClass:[XECDSAPubKey class]]) {
        if (error) *error = [NSError errorWithDomain:@"keypair is not a XECDSAPubKey object" code:-1 userInfo:nil];
        return nil;
    }
    
    return publickey.address;
}

/// 验证钱包地址是否是合法的格式。如果成功，返回true和对应的版本号；如果失败，返回false和默认的版本号0
- (BOOL) checkFormatWithAddress:(XAddress _Nonnull)address version:( unsigned int * _Nullable )version error:(NSError * _Nonnull * _Nullable)error {
    
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
        if (error) *error = [NSError errorWithDomain:@"this cryptography has not been supported yet." code:-1 userInfo:nil];
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
        if (error) *error = [NSError errorWithDomain:@"invaild address." code:-1 userInfo:nil];
        return false;
    }
    
    return true;
}

/// 验证钱包地址是否和指定的公钥match。如果成功，返回true和对应的版本号；如果失败，返回false和默认的版本号0
- (BOOL) verifyUsingPublicKeyWithAddress:(XAddress _Nonnull)address publicKey:(id<XCryptoPubKeyProtocol> _Nonnull)publickey version:(NSUInteger * _Nullable)version error:(NSError * _Nonnull * _Nullable)error {
        
    if ( ![address.lowercaseString isEqualToString:publickey.address.lowercaseString] ) {
        if (version) *version = 0;
        return false;
    }
    
    if ( version ){
        [[NSData xFromBase58String:address] getBytes:version range:NSMakeRange(0, 1)];
    }
    
    return false;
}

- (NSDate * _Nullable)decryptWithPrivateKey:(id<XCryptoPubKeyProtocol> _Nonnull)privatekey cypherRawMessage:(NSData * _Nonnull)rawmessage error:(NSError * _Nonnull __autoreleasing * _Nullable)error {
    return nil;
}

- (NSData * _Nullable)encryptWithPublickKey:(id<XCryptoPubKeyProtocol> _Nonnull)publickey rawMessage:(NSData * _Nonnull)rawmessage error:(NSError * _Nonnull __autoreleasing * _Nullable)error {
    return nil;
}

- (BOOL)xuperVerifyWithPublicKeys:(NSArray<id<XCryptoPubKeyProtocol>> * _Nonnull)publickeys signature:(XSignature _Nonnull)signature rawMessage:(NSData * _Nonnull)rawmessage error:(NSError * _Nonnull __autoreleasing * _Nullable)error {
    
    if ( publickeys.count <= 0 || !signature || !rawmessage || rawmessage.length ) {
        return false;
    }
    
    for ( id<XCryptoPubKeyProtocol> pubkey in publickeys ) {
        
        [self verifyWithPublicKey:pubkey signature:signature rawMessage:rawmessage error:error];
        
        if ( error && *error ) {
            return false;
        }
        
    }
    
    return true;
}


- (id<XCryptoPubKeyProtocol>)getPublicKeyFromJSON:(XJsonString)jsonString error:(NSError * _Nonnull * _Nullable)error {
    return [[XECDSAPubKey alloc] initWithJsonFormatString:jsonString error:error];
}

- (id<XCryptoAccountProtocol> _Nullable) getPrivateKeyFromJSON:(XJsonString _Nonnull)jsonString error:(NSError * _Nonnull * _Nullable)error {
    
    XECDSAPrivKey *pk = [[XECDSAPrivKey alloc] initWithJsonFormatString:jsonString error:error];
    if (!pk) {
        return nil;
    }
    
    return [XECDSAAccount fromPrivateKey:pk];
}

/// 获取私钥的json格式的表达
- (XJsonString _Nullable) getPrivateKeyJSONFormat:(id<XCryptoAccountProtocol> _Nullable)keypair error:(NSError * _Nonnull * _Nullable)error {
    
    if ( ![keypair isKindOfClass:[XECDSAAccount class]] ) {
        if (error) *error = [NSError errorWithDomain:@"keypair is not a XECDSAAccount object" code:-1 userInfo:nil];
        return nil;
    }
    
    return ((XECDSAAccount*)keypair).jsonPrivateKey;
}

/// 获取ECC公钥的json格式的表达
- (XJsonString _Nullable) getPublicKeyJSONFormat:(id<XCryptoAccountProtocol> _Nullable)keypair error:(NSError * _Nonnull * _Nullable)error {
    
    if ( ![keypair isKindOfClass:[XECDSAAccount class]] ) {
        if (error) *error = [NSError errorWithDomain:@"keypair is not a XECDSAAccount object" code:-1 userInfo:nil];
        return nil;
    }
    
    return ((XECDSAAccount*)keypair).jsonPublicKey;
}

/// 从导出的私钥文件读取私钥的byte格式
- (id<XCryptoAccountProtocol> _Nullable) getPrivateKeyFromFilePath:(NSString * _Nonnull)path error:(NSError * _Nonnull * _Nullable)error {
    
    NSFileManager *fs = NSFileManager.defaultManager;
    
    BOOL isDir = false;
    if ( ![fs fileExistsAtPath:path isDirectory:&isDir] ) {
        if (error) *error = [NSError errorWithDomain:@"path not found." code:-1 userInfo:nil];
        return nil;
    }
    
    if ( !isDir ) {
        if (error) *error = [NSError errorWithDomain:@"path is exist but not directory." code:-1 userInfo:nil];
        return nil;
    }
    
    NSString *pkPath = [path stringByAppendingPathExtension:@"private.key"];
    if ( ![fs fileExistsAtPath:pkPath] ) {
        if (error) *error = [NSError errorWithDomain:@"not found file \"private.key\" in path." code:-1 userInfo:nil];
        return nil;
    }
    
    NSError *readError;
    NSString *jpkcontent = [[NSString alloc] initWithContentsOfFile:pkPath encoding:NSUTF8StringEncoding error:&readError];
    if ( readError ) {
        if (error) *error = readError;
        return nil;
    }
    
    return [self getPrivateKeyFromJSON:jpkcontent error:error];
}

- (id<XCryptoPubKeyProtocol> _Nullable) getPublicKeyFromFilePath:(NSString * _Nonnull)path error:(NSError * _Nonnull * _Nullable)error {
    
    NSFileManager *fs = NSFileManager.defaultManager;
    
    BOOL isDir = false;
    if ( ![fs fileExistsAtPath:path isDirectory:&isDir] ) {
        if (error) *error = [NSError errorWithDomain:@"path not found." code:-1 userInfo:nil];
        return nil;
    }
    
    if ( !isDir ) {
        if (error) *error = [NSError errorWithDomain:@"path is exist but not directory." code:-1 userInfo:nil];
        return nil;
    }
    
    NSString *pkPath = [path stringByAppendingPathExtension:@"public.key"];
    if ( ![fs fileExistsAtPath:pkPath] ) {
        if (error) *error = [NSError errorWithDomain:@"not found file \"public.key\" in path." code:-1 userInfo:nil];
        return nil;
    }
    
    NSError *readError;
    NSString *jpkcontent = [[NSString alloc] initWithContentsOfFile:pkPath encoding:NSUTF8StringEncoding error:&readError];
    if ( readError ) {
        if (error) *error = readError;
        return nil;
    }
    
    return [self getPublicKeyFromJSON:jpkcontent error:error];
    
}

- (id<XCryptoAccountProtocol> _Nonnull) exportNewAccount:(NSString * _Nonnull)path error:(NSError * _Nullable * _Nonnull)error {
    
    NSFileManager *fs = NSFileManager.defaultManager;
    
    if ( [fs fileExistsAtPath:path] ) {
        if (error) *error = [NSError errorWithDomain:@"path is already exist." code:-1 userInfo:nil];
        return nil;
    }
    
    XECDSAAccount *newAK = self.generateKey;
    
    NSError *writeError;
    NSString *addressPath = [path stringByAppendingPathComponent:@"address"];
    NSString *pubkeyPath = [path stringByAppendingPathExtension:@"public.key"];
    NSString *privKeyPath = [path stringByAppendingPathExtension:@"private.key"];
    @try {
        
        [newAK.address writeToFile:addressPath atomically:YES encoding:NSUTF8StringEncoding error:&writeError];
        if (writeError) {
            @throw [NSException exceptionWithName:@"WriteError" reason:nil userInfo:nil];
        }
        
        [newAK.publicKey.jsonFormatString writeToFile:pubkeyPath atomically:YES encoding:NSUTF8StringEncoding error:&writeError];
        if (writeError) {
            @throw [NSException exceptionWithName:@"WriteError" reason:nil userInfo:nil];
        }
        
        [newAK.privateKey.jsonFormatString writeToFile:privKeyPath atomically:YES encoding:NSUTF8StringEncoding error:&writeError];
        if (writeError) {
            @throw [NSException exceptionWithName:@"WriteError" reason:nil userInfo:nil];
        }
        
        return newAK;
        
    } @catch (NSException *exception) {
        
        [fs removeItemAtPath:addressPath error:nil];
        [fs removeItemAtPath:pubkeyPath error:nil];
        [fs removeItemAtPath:privKeyPath error:nil];
        
        if (error) *error = writeError;
        
        return nil;
    }
    
}

/// Entropy的最后一个字节，即最后8位，是xuper的自定义字段！！即总和“创建综合标记位”
/// ECDSA的实现应该对应（二进制） 0000 0001
- (NSData * _Nonnull) generateEntropyWithBitSize:(int)bitSize error:(NSError * _Nonnull * _Nullable)error {
    
    if ( bitSize % 8 != 0 ) {
        
        if (error) *error = [NSError errorWithDomain:@"path is already exist." code:-1 userInfo:nil];
        
        return nil;
    }
    
    return [XBIP39 generateEntropyWithStrength:bitSize];
}

- (id<XBIP39AccountProtocol> _Nullable) createNewAccountWithMnemonicLanguage:(BIP39MnemonicLanguage)language strength:(BIP39MnemonicStrength)strength password:(NSString * _Nullable)password error:(NSError * _Nonnull * _Nullable)error {
    
    //  checksum length (CS)
    //  entropy length (ENT)
    //  mnemonic sentence (MS)
    //
    //    CS = ENT / 32
    //    MS = (ENT + CS) / 11
    //
    //    |  ENT  | CS | ENT+CS |  MS  |
    //    +-------+----+--------+------+
    //    |  128  |  4 |   132  |  12  |
    //    |  160  |  5 |   165  |  15  |
    //    |  192  |  6 |   198  |  18  |
    //    |  224  |  7 |   231  |  21  |
    //    |  256  |  8 |   264  |  24  |
    //
    // uint32_t ENT = 128;
    // uint32_t CS = ENT / 32;
    // uint32_t MS = (ENT + CS) / 11;
    
    /// 1.生成熵
    NSData *entropy = [self generateEntropyWithBitSize:(int)strength error:nil];
    
    /// 2.获得熵对应的助记词
    NSArray<NSString*> *mnemonics = [XBIP39 generateMnemonicWithEntropy:entropy language:language];
    
    return [XECDSABIP39Account fromMnemonics:[mnemonics componentsJoinedByString:@" "] pwd:password language:language];
}

- (id<XCryptoAccountProtocol> _Nullable) generateKeyBySeed:(NSData * _Nonnull)seed {
    
    XECDSAPrivKey *pk = [XECDSAPrivKey generateKeyBySeed:seed];
    
    return [XECDSAAccount fromPrivateKey:pk];
}

- (id<XCryptoAccountProtocol> _Nullable) retrieveAccountByPrivateKeyJsongString:(NSString * _Nonnull)pkjson {
    
    NSError *error;
    XECDSAPrivKey *pk = [[XECDSAPrivKey alloc] initWithJsonFormatString:pkjson error:&error];
    if (error) {
        return nil;
    }
    
    return [XECDSAAccount fromPrivateKey:pk];
}

- (id<XBIP39AccountProtocol> _Nullable) retrieveAccountByMnemonic:(NSString * _Nonnull)mnemonic password:(NSString * _Nullable)password language:(BIP39MnemonicLanguage)language {
    return [XECDSABIP39Account fromMnemonics:mnemonic pwd:password language:language];
}

- (id<XBIP39AccountProtocol> _Nullable) exportNewAccountWithMnemonicToPath:(NSString * _Nonnull)path language:(BIP39MnemonicLanguage)languag strength:(BIP39MnemonicStrength)strength password:(NSString * _Nonnull)password error:(NSError * _Nonnull * _Nullable)error {
    
    NSFileManager *fs = NSFileManager.defaultManager;
    
    if ( [fs fileExistsAtPath:path] ) {
        if (error) *error = [NSError errorWithDomain:@"path is already exist." code:-1 userInfo:nil];
        return nil;
    }
    
    NSError *internalError;
    XECDSABIP39Account *newAK = [self createNewAccountWithMnemonicLanguage:languag strength:strength password:password error:&internalError];
    if (internalError) {
        if ( error ) *error = internalError;
        return nil;
    }
    
    NSError *writeError;
    NSString *addressPath = [path stringByAppendingPathComponent:@"address"];
    NSString *pubkeyPath = [path stringByAppendingPathExtension:@"public.key"];
    NSString *privKeyPath = [path stringByAppendingPathExtension:@"private.key"];
    NSString *mnemonicPath = [path stringByAppendingPathExtension:@"mnemonic"];
    @try {
        
        [newAK.address writeToFile:addressPath atomically:YES encoding:NSUTF8StringEncoding error:&writeError];
        if (writeError) {
            @throw [NSException exceptionWithName:@"WriteError" reason:nil userInfo:nil];
        }
        
        [newAK.publicKey.jsonFormatString writeToFile:pubkeyPath atomically:YES encoding:NSUTF8StringEncoding error:&writeError];
        if (writeError) {
            @throw [NSException exceptionWithName:@"WriteError" reason:nil userInfo:nil];
        }
        
        [newAK.privateKey.jsonFormatString writeToFile:privKeyPath atomically:YES encoding:NSUTF8StringEncoding error:&writeError];
        if (writeError) {
            @throw [NSException exceptionWithName:@"WriteError" reason:nil userInfo:nil];
        }
        
        [[newAK.mnemonics componentsJoinedByString:@" "] writeToFile:mnemonicPath atomically:YES encoding:NSUTF8StringEncoding error:&writeError];
        if (writeError) {
            @throw [NSException exceptionWithName:@"WriteError" reason:nil userInfo:nil];
        }
        
        return newAK;
        
    } @catch (NSException *exception) {
        
        [fs removeItemAtPath:addressPath error:nil];
        [fs removeItemAtPath:pubkeyPath error:nil];
        [fs removeItemAtPath:privKeyPath error:nil];
        [fs removeItemAtPath:mnemonicPath error:nil];
        
        if (error) *error = writeError;
        
        return nil;
    }
    
}

@end
