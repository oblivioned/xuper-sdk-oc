//
//  XCryptoClient.h
//  xuper-sdk-oc
//
//  Created by apple on 2019/11/29.
//  Copyright © 2019 Martin.Ren. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "XCommon.h"

#import "XCryptoKeypairProtocol.h"
#import "XCryptoAccountProtocol.h"

@protocol XCryptoClientCore <NSObject>

- (id<XCryptoAccountProtocol> _Nullable) generateKeyWithError:(NSError * _Nullable * _Nonnull)err;

/// 使用ECC私钥来签名
- (NSData * _Nullable) signRawMessage:(NSData * _Nonnull)rawmessage keypair:(id<XCryptoKeypairProtocol> _Nonnull)keypair error:(NSError * _Nullable * _Nonnull)err;

/// 使用ECC公钥来验证签名
- (BOOL) verifyWithPublicKey:(id<XCryptoPubKeyProtocol> _Nonnull)publickey signature:(XSignature _Nonnull)signature rawMessage:(NSData * _Nonnull)rawmessage error:(NSError * _Nullable * _Nonnull)err;

/// 通过公钥来计算地址
- (XAddress _Nullable) getAddressWithPublicKey:(id<XCryptoPubKeyProtocol> _Nonnull)publickey error:(NSError * _Nullable * _Nonnull)err;

/// 验证钱包地址是否是合法的格式。如果成功，返回true和对应的版本号；如果失败，返回false和默认的版本号0
- (BOOL) checkFormatWithAddress:(XAddress _Nonnull)address version:( unsigned int * _Nullable )version error:(NSError * _Nullable * _Nonnull)err;

/// 验证钱包地址是否和指定的公钥match。如果成功，返回true和对应的版本号；如果失败，返回false和默认的版本号0
- (BOOL) verifyUsingPublicKeyWithAddress:(XAddress _Nonnull)address publicKey:(id<XCryptoPubKeyProtocol> _Nonnull)publickey version:(uint8_t * _Nullable * _Nonnull)version error:(NSError * _Nullable * _Nonnull)err;

/// 统一签名验签接口，支持普通签名、多重签名、环签名的验签
- (BOOL) xuperVerifyWithPublicKeys:(NSArray<id<XCryptoPubKeyProtocol>> * _Nonnull)publickeys signature:(XSignature _Nonnull)signature rawMessage:(NSData * _Nonnull)rawmessage error:(NSError * _Nullable * _Nonnull)err;

/// 使用ECIES加密
- (NSData * _Nullable) encryptWithPublickKey:(id<XCryptoPubKeyProtocol> _Nonnull)publickey rawMessage:(NSData * _Nonnull)rawmessage error:(NSError * _Nullable * _Nonnull)err;

/// 使用ECIES解密
- (NSDate * _Nullable) decryptWithPrivateKey:(id<XCryptoPubKeyProtocol> _Nonnull)privatekey cypherRawMessage:(NSData * _Nonnull)rawmessage error:(NSError * _Nullable * _Nonnull)err;

@end


@protocol XAccountUtilsProtocol <NSObject>

/// 创建新的账户，不需要助记词。生成如下几个文件：1.私钥，2.公钥，3.钱包地址 (不建议使用)
- (void) exportNewAccount:(NSString * _Nonnull)path error:(NSError * _Nullable * _Nonnull)error;

/// 创建含有助记词的新的账户，返回的字段：（助记词、私钥的json、公钥的json、钱包地址） as ECDSAAccount，以及可能的错误信息
- (id<XCryptoAccountProtocol> _Nullable) createNewAccountWithMnemonicLanguage:(int)language strength:(uint)strength error:(NSError * _Nullable * _Nonnull)error;

/// 创建新的账户，并导出相关文件（含助记词）到本地。生成如下几个文件：1.助记词，2.私钥，3.公钥，4.钱包地址
- (id<XCryptoAccountProtocol> _Nullable) exportNewAccountWithMnemonicLanguage:(int)languag strength:(uint)strength error:(NSError * _Nullable * _Nonnull)error;

/// 从助记词恢复钱包账户
- (id<XCryptoAccountProtocol> _Nullable) retrieveAccountByMnemonic:(NSString * _Nonnull)mnemonic language:(int)language error:(NSError * _Nullable * _Nonnull)error;

/// 从助记词恢复钱包账户，并用支付密码加密私钥后存在本地，
/// 返回的字段：（随机熵（供其他钱包软件推导出私钥）、助记词、私钥的json、公钥的json、钱包地址） as ECDSAAccount，以及可能的错误信息
- (id<XCryptoKeyInfo> _Nullable) retrieveAccountByMnemonicAndSavePrivKeyToPath:(NSString * _Nonnull)path language:(int)language mnemonic:(NSString * _Nonnull)mnemoni password:(NSString * _Nonnull)password error:(NSError * _Nullable * _Nonnull)error;

/// 将随机熵转为助记词
- (NSString * _Nullable) generateMnemonicWithEntropy:(NSData * _Nonnull)entropy language:(int)language error:(NSError * _Nullable * _Nonnull)error;

/// 将助记词转为指定长度的随机数种子，在此过程中，校验助记词是否合法
- (NSData * _Nullable) generateSeedErrorCheckingWithMnemonic:(NSString * _Nonnull)mnemonic password:(NSString * _Nonnull)password keylen:(int)keylen language:(int)language error:(NSError * _Nullable * _Nonnull)error;

/////////////////////////////////////////////
// 暂不支持
// 创建新的账户，并用支付密码加密私钥后存在本地，
// 返回的字段：（随机熵（供其他钱包软件推导出私钥）、助记词、私钥的json、公钥的json、钱包地址） as ECDSAAccount，以及可能的错误信息
//CreateAndSaveSecretKey(path string, nVersion uint8, language int, strength uint8, password string) (*account.ECDSAInfo, error)
// 使用支付密码加密账户信息并返回加密后的数据（后续用来回传至云端）
//EncryptAccount(info *account.ECDSAAccount, password string) (*account.ECDSAAccountToCloud, error)

@end

@protocol XCryptoUtilsProtocol <NSObject>

/// 从导出的私钥文件读取私钥的byte格式
- (NSData * _Nullable) getBinaryPrivateKeyFromFilePath:(NSString * _Nonnull)path password:(NSString * _Nonnull)password error:(NSError * _Nullable * _Nonnull)error;

/// 从导出的私钥文件读取私钥
- (id<XCryptoAccountProtocol> _Nullable) getPrivateKeyFromFilePath:(NSString * _Nonnull)path error:(NSError * _Nullable * _Nonnull)error;

/// 使用支付密码从导出的私钥文件读取私钥
- (id<XCryptoAccountProtocol> _Nullable) getPrivateKeyFromFilePath:(NSString * _Nonnull)path password:(NSString * _Nonnull)password error:(NSError * _Nullable * _Nonnull)error;

/// 从二进制加密字符串获取真实私钥的byte格式
- (id<XCryptoAccountProtocol> _Nullable) getBinaryPrivateKeyFromString:(NSString * _Nonnull)string password:(NSString * _Nonnull)password error:(NSError * _Nullable * _Nonnull)error;

/// 从导出的公钥文件读取公钥
- (id<XCryptoPubKeyProtocol> _Nullable) getPublicKeyFromFilePath:(NSString * _Nonnull)path error:(NSError * _Nullable * _Nonnull)error;

/// 产生随机熵
- (NSData * _Nullable) generateEntropyWithBitSize:(int)bitSize error:(NSError * _Nullable * _Nonnull)error;

/// 从导出的私钥文件读取私钥
- (id<XCryptoAccountProtocol> _Nullable) getPrivateKeyFromJSON:(XJsonString _Nonnull)jsonBytes error:(NSError * _Nullable * _Nonnull)error;

// 从导出的公钥文件读取公钥
- (id<XCryptoPubKeyProtocol> _Nullable) getPublicKeyFromJSON:(XJsonString _Nonnull)jsonBytes error:(NSError * _Nullable * _Nonnull)error;

/// 获取私钥的json格式的表达
- (XJsonString _Nullable) getPrivateKeyJSONFormat:(id<XCryptoAccountProtocol> _Nullable)keypair error:(NSError * _Nullable * _Nonnull)error;

/// 获取ECC公钥的json格式的表达
- (XJsonString _Nullable) getPublicKeyJSONFormat:(id<XCryptoAccountProtocol> _Nullable)keypair error:(NSError * _Nullable * _Nonnull)error;

@end

// MultiSig 多重签名相关接口, interface for Multisig
@protocol XCryptoMultiSigProtocol <NSObject>

/// GetRandom32Bytes 每个多重签名算法流程的参与节点生成32位长度的随机byte，返回值可以认为是k
- (NSData * _Nonnull) getRandom32Bytes;

/// GetRiUsingRandomBytes 每个多重签名算法流程的参与节点生成Ri = Ki*G
- (NSData * _Nonnull) getRiUsingRandomBytes:(id<XCryptoPubKeyProtocol> _Nonnull)key k:(NSData * _Nonnull)k;

/// GetRUsingAllRi 负责计算多重签名的节点来收集所有节点的Ri，并计算R = k1*G + k2*G + ... + kn*G
- (NSData * _Nonnull) getRUsingAllRiWithPublickKey:(id<XCryptoPubKeyProtocol> _Nonnull)key arrayOfRi:(NSArray<NSData*>* _Nonnull)arrayOfRi;

/// GetSharedPublicKeyForPublicKeys 负责计算多重签名的节点来收集所有节点的公钥Pi，并计算公共公钥：C = P1 + P2 + ... + Pn
- (NSData * _Nullable) getSharedPublicKeyForPublicKeys:(NSArray<id<XCryptoPubKeyProtocol>>* _Nonnull)keys error:(NSError * _Nullable * _Nonnull)error;

/// GetSiUsingKCRM 负责计算多重签名的节点将计算出的R和C分别传递给各个参与节点后，由各个参与节点再次计算自己的Si
/// 计算 Si = Ki + HASH(C,R,m) * Xi
/// X代表大数D，也就是私钥的关键参数
- (NSData * _Nonnull) getSiUsingKCRMWithPrivateKey:(id<XCryptoAccountProtocol> _Nullable)key k:(NSData * _Nonnull)k c:(NSData * _Nonnull)c r:(NSData * _Nonnull)r message:(NSData * _Nonnull)message;

/// GetSUsingAllSi 负责计算多重签名的节点来收集所有节点的Si，并计算出S = sum(si)
- (NSData * _Nonnull) getSUsingAllSiWithArray:(NSArray<NSData*>* _Nonnull)arrayOfSi;

/// GenerateMultiSignSignature 负责计算多重签名的节点，最终生成多重签名的统一签名格式
- (NSData * _Nullable) generateMultiSignSignatureWithS:(NSData * _Nonnull)s r:(NSData * _Nonnull)r error:(NSError * _Nullable * _Nonnull)error;

/// VerifyMultiSig 使用ECC公钥数组来进行多重签名的验证
- (NSData * _Nullable) verifyMultiSigWithPubkeys:(NSArray<id<XCryptoPubKeyProtocol>> * _Nonnull)keys signature:(NSData * _Nonnull)signature message:(NSData * _Nonnull)message error:(NSError * _Nullable * _Nonnull)error;

/// MultiSign  多重签名的另一种用法，适用于完全中心化的流程
/// 使用ECC私钥数组来进行多重签名，生成统一签名格式
- (NSData * _Nullable) multiSignWithPrivateKeys:(NSArray<id<XCryptoAccountProtocol>> * _Nonnull)keys message:(NSData * _Nonnull)message error:(NSError * _Nullable * _Nonnull)error;

@end

@protocol XCryptoClientProtocol
<
XCryptoClientCore,
XCryptoUtilsProtocol,
XAccountUtilsProtocol,
XCryptoMultiSigProtocol
>

@end


