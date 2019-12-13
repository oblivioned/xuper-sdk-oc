//
//  XECDSAPrivKey.h
//  xuper-sdk-oc
//
//  Created by apple on 2019/12/2.
//  Copyright © 2019 Martin.Ren. All rights reserved.
//

#import <openssl/bn.h>

#import "XCommon.h"

#import "XCryptoPrivKeyProtocol.h"
#import "XCryptoPubKeyProtocol.h"

@interface XECDSAPrivKey : NSObject <XCryptoPrivKeyProtocol>

/**
 * 从json文件中创建私钥对象
 * \param  keydata  json文件的实际内容
 * \return XECDSAPrivKey* or NULL
*/
+ (instancetype _Nullable) fromExportedJsonContent:(NSData* _Nonnull)keydata;

/**
 * 从json文件中创建私钥对象
 * \param  keydict  由json转换的NSDictionary对象，其中应该包括(Curvname, X, Y, D) 4个字段
 * \return XECDSAPrivKey* or NULL
*/
+ (instancetype _Nullable) fromExportedDictionary:(NSDictionary* _Nonnull)keydict;

- (id<XCryptoPubKeyProtocol> _Nonnull) publicKey;

+ (instancetype _Nullable) generateKey;

@end
