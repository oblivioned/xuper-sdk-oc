//
//  BIP39.h
//  xuper-sdk-oc
//
//  Created by apple on 2019/12/16.
//  Copyright © 2019 Martin.Ren. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    
    BIP39MnemonicStrength_Easy      = 128 - 8,
    BIP39MnemonicStrength_Midden    = 192 - 8,
    BIP39MnemonicStrength_Hard      = 256 - 8
    
} BIP39MnemonicStrength;

typedef enum : NSUInteger {
    
    /// 默认
    BIP39MnemonicLanguage_Default = 1,
    
    /// 简体中文
    BIP39MnemonicLanguage_ChineseSimplified = BIP39MnemonicLanguage_Default,
    
    /// 英语
    BIP39MnemonicLanguage_English,
    
    /// 繁体中文
    /// BIP39MnemonicLanguage_ChineseTraditional,
    
    /// 法语
    /// BIP39MnemonicLanguage_French,
    
    /// 意大利语
    /// BIP39MnemonicLanguage_Italian,
    
    /// 西班牙语
    /// BIP39MnemonicLanguage_Spanish,
    
    /// 日语？不好意思看不懂，不支持，斯密码森！略略略～～～
    /// BIP39MnemonicLanguage_Japanese,
    
} BIP39MnemonicLanguage;

/// !!!! 请注意，这是一个xuper修改过后的BIP39，并非标准！并非标准！并非标准！的BIP39，所以命名为XBIP39
@interface XBIP39 : NSObject

/// 生产一个指定长度的熵
+ (NSData * _Nonnull) generateEntropyWithStrength:(NSUInteger)strength;

/// 根据熵转换为词组
+ (NSArray<NSString*> * _Nonnull) generateMnemonicWithEntropy:(NSData * _Nonnull)entropy language:(BIP39MnemonicLanguage)language;

/// 根据助记词生成seed,pwd = nil 时使用默认密码
+ (NSData * _Nonnull) seedFromMnemonics:(NSArray<NSString*> * _Nonnull)mnemonic password:(NSString * _Nullable)pwd;

/// 获取单词表
+ (NSArray<NSString*> * _Nonnull) getWordListByLanguage:(BIP39MnemonicLanguage)language;

/// 根据助记词和语言，还原原始熵
//+ (NSData * _Nullable) getEntropyFromMnemonics:(NSArray<NSString*> * _Nonnull)mnemonics language:(BIP39MnemonicLanguage)language;

@end
