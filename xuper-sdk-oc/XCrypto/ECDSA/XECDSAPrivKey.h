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

+ (instancetype _Nullable) generateKey;

+ (instancetype _Nullable) generateKeyBySeed:(NSData * _Nonnull)seed;

/*!
 * 注意一定Value一定要是String，一定要是String，一定要是String
 * 因为默认在go版本的xuper中，导出的私钥是10进制表示的超大数，而objectiv-c是无法正常识别的，所以一定要手动转换成string
 */
+ (instancetype _Nullable) fromExportedDictionary:(NSDictionary<NSString*, NSString*> * _Nonnull)keydict;

- (instancetype _Nullable) initWithJsonFormatString:(NSString * _Nonnull)ppjson error:(NSError * _Nonnull * _Nullable)error;

- (instancetype _Nullable) initWithDictionary:(NSDictionary<NSString*, NSString*> * _Nonnull)keydict;

- (id<XCryptoPubKeyProtocol> _Nonnull) publicKey;

@end
