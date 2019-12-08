//
//  XTransactionGlobalFlags.h
//  xuper-sdk-oc-iOS
//
//  Created by apple on 2019/12/6.
//  Copyright © 2019 Martin.Ren. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XCommon.h"

XSDKExtern XCryptoTypeStringKey const _Nonnull XCryptoTypeStringKeyDefault;
XSDKExtern XCryptoTypeStringKey const _Nonnull XCryptoTypeStringKeyECC;

@interface XGlobalFlags : NSObject

/// 链名，默认：xuper
@property (nonatomic, copy) NSString * _Nonnull blockchainName;

/// 私钥路径？暂定，因为本地生成了私钥，可能考虑回直接使用keypair独享代替keypath
@property (nonatomic, copy) NSString * _Nonnull keyPath;

/// 加密算法，默认：defalt 对应ECDSA
@property (nonatomic, copy) XCryptoTypeStringKey _Nonnull cryptoType;

+ (instancetype _Nonnull) appearance;

@end
