//
//  BIP39.m
//  xuper-sdk-oc
//
//  Created by apple on 2019/12/16.
//  Copyright © 2019 Martin.Ren. All rights reserved.
//

#import <openssl/evp.h>
#import <openssl/ecdsa.h>

#import "BIP39.h"

#import "bip39_chinese_simplified.h"
#import "bip39_english.h"
#import "XBigInt.h"

@implementation XBIP39

+ (NSData * _Nonnull) generateEntropyWithStrength:(NSUInteger)strength {

    if ( strength % 8 != 0 ) {
        return nil;
    }
    
    int byteSize = (int)strength / 8;
    
    char *entropy = malloc(byteSize);
    
    arc4random_buf(entropy, byteSize);
    
    /// 清空最后8位,设置为1
    memset(entropy + (byteSize - 1), 0b00000001, 1);
    
    NSData *r = [NSData dataWithBytes:entropy length:byteSize];
    
    free(entropy);
    
    return r;
}

+ (NSArray<NSString*> * _Nonnull) getWordListByLanguage:(BIP39MnemonicLanguage)language {

    switch (language) {
            
        default:
        case BIP39MnemonicLanguage_ChineseSimplified:   return BIP39_WordList_Chinese_Simplified;
//        case BIP39MnemonicLanguage_ChineseTraditional:  return BIP39_WordList_Chinese_Traditional;
        case BIP39MnemonicLanguage_English:             return BIP39_WordList_English;
//        case BIP39MnemonicLanguage_French:              return BIP39_WordList_French;
//        case BIP39MnemonicLanguage_Italian:             return BIP39_WordList_Italian;
//        case BIP39MnemonicLanguage_Spanish:             return BIP39_WordList_Spanish;
    }
    
}

+ (NSArray<NSString*> * _Nonnull) generateMnemonicWithEntropy:(NSData * _Nonnull)entropy language:(BIP39MnemonicLanguage)language {
    
    NSMutableArray<NSString*> *words = [[NSMutableArray alloc] init];
    
    /// 1.计算熵的Hash512
    /// 熵值按照11bits分割
    XBigInt *entropyInt = [[XBigInt alloc] initWithData:entropy];
    
    XBigInt *bit11Mod = [[XBigInt alloc] initWithUInt:2048];
    
    /// 实际是对这个数字不停的除以2048后取出余数，直到被除数为0
    do {
        
        XBigInt *rem = [entropyInt divRemBigInt:bit11Mod];
        
        /// 余数转换为int类型,严格上来说这个是一个不安全的方法，但是因为余数不会超过2048，在int的取值范围之内
        int remInt = atoi([rem.decString dataUsingEncoding:NSUTF8StringEncoding].bytes);
        
        [words addObject:[self getWordListByLanguage:language][remInt]];
        
    } while ( [entropyInt greaterThan:XBigInt.Zero] );
    
    return words;
}

+ (NSData * _Nullable) getEntropyFromMnemonics:(NSArray<NSString*> * _Nonnull)mnemonics language:(BIP39MnemonicLanguage)language {
    
    NSArray *wordList = [self getWordListByLanguage:language];
    
    XBigInt *entropyBN = XBigInt.Zero;
    
    XBigInt *bit11Mod = [[XBigInt alloc] initWithUInt:2048];
    
    /// 从后往前
    for ( NSUInteger i = mnemonics.count - 1; i > 0; i-- ) {
        
        NSString *m = mnemonics[i];
        
        if ( ![wordList containsObject:m] ) {
            return nil;
        }
        
        NSUInteger n = [wordList indexOfObject:m];
        
        /// 实际是 r = r * 2048 + n
        [entropyBN mulBigInt:bit11Mod];
        [entropyBN addBigInt:[[XBigInt alloc] initWithUInt:n]];
    }
    
    return entropyBN.data;
}

+ (NSData * _Nonnull) seedFromMnemonics:(NSArray<NSString*> * _Nonnull)mnemonic password:(NSString * _Nullable)pwd {
    
    NSString *slat = @"mnemonicjingbo is handsome!";
    if ( pwd && pwd.length > 0 ) {
        slat = [NSString stringWithFormat:@"mnemonic%@", pwd];
    }
    
    NSData *mnemonicsData = [[mnemonic componentsJoinedByString:@" "] dataUsingEncoding:NSUTF8StringEncoding];
    NSData *slatData = [slat dataUsingEncoding:NSUTF8StringEncoding];
    
    unsigned char *seed = malloc( 40 );
    
    PKCS5_PBKDF2_HMAC(mnemonicsData.bytes,
                      (int)mnemonicsData.length,
                      slatData.bytes,
                      (int)slatData.length,
                      2048,
                      EVP_sha512(),
                      40,
                      seed);
        
    /// 5.根据seed求取私钥 GenerateKeyBySeed
    EC_GROUP *_ec_group = EC_GROUP_new_by_curve_name(NID_X9_62_prime256v1);
    
    BN_CTX *_ctx = BN_CTX_new();
    BIGNUM *_orderN = BN_new();
    
    EC_GROUP_get_order(_ec_group, _orderN, _ctx);
    
    XBigInt *n = [[XBigInt alloc] initWithHexString:[NSString stringWithUTF8String:BN_bn2hex(_orderN)]];
    BN_free(_orderN);
    BN_CTX_free(_ctx);
    
    XBigInt *k = [[XBigInt alloc] initWithData:[NSData dataWithBytes:seed length:40]];
    
    [n subBigInt:XBigInt.One];
    
    k = [k bigIntByModBigInt:n];
    
    [k addBigInt:XBigInt.One];
    
    return k.data;
}

@end
