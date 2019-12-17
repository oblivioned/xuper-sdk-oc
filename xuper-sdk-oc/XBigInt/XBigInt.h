//
//  XBigInt.h
//  xuper-sdk-oc-iOS
//
//  Created by apple on 2019/12/6.
//  Copyright © 2019 Martin.Ren. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <openssl/bn.h>

#import "XCommon.h"

/// 使用openssl实现，单纯的方法转接，方便使用,
/// 目前只实现常用的转换，暂时没有计算相关
@interface XBigInt : NSObject <NSCopying>

+ (instancetype _Nonnull) Zero;

+ (instancetype _Nonnull) One;

/**
 * 使用十六进制字符串生成XBigInt对象，不区分大小写
 * \param  hexString 0xFF, FF, 0xff, ff ...
 * \return XBigInt*
*/
- (instancetype _Nonnull) initWithHexString:( XHexString _Nonnull )hexString;

/**
 * 使用十进制字符串生成XBigInt对象
 * \param  decString 如"12381293719827389172893718923"
 * \return XBigInt*
*/
- (instancetype _Nonnull) initWithDecString:( NSString * _Nonnull )decString;

- (instancetype _Nonnull) initWithData:( NSData * _Nonnull )data;

- (instancetype _Nonnull) initWithUInt:(NSUInteger)n;

/**
 * 获取十六进制表示的数字
*/
- (NSString * _Nonnull) hexString;

/**
 * 获取十进制表示的数字
*/
- (NSString * _Nonnull) decString;

/**
 * 获取base64表达的数字
*/
- (NSString * _Nonnull) base64String;

/**
 * 获取二进制，一般用于数据传输前
 * \return NSData * _Nonnull
*/
- (NSData * _Nonnull) data;


#pragma mark - 加法
- (void) addBigInt:(XBigInt * _Nonnull)a;
- (void) addBigIntHex:(XHexString _Nonnull)aHex;
- (void) addBigIntDec:(NSString * _Nonnull)adec;

- (XBigInt * _Nonnull) bigIntByAddBigInt:(XBigInt * _Nonnull)a;
- (XBigInt * _Nonnull) bigIntByAddBigIntHex:(XHexString _Nonnull)aHex;
- (XBigInt * _Nonnull) bigIntByAddBigIntDec:(NSString * _Nonnull)adec;

#pragma mark - 减法
- (void) subBigInt:(XBigInt * _Nonnull)a;
- (void) subBigIntHex:(XHexString _Nonnull)aHex;
- (void) subBigIntDec:(NSString * _Nonnull)adec;

- (XBigInt * _Nonnull) bigIntBySubBigInt:(XBigInt * _Nonnull)a;
- (XBigInt * _Nonnull) bigIntBySubBigIntHex:(XHexString _Nonnull)aHex;
- (XBigInt * _Nonnull) bigIntBySubBigIntDec:(NSString * _Nonnull)adec;

#pragma mark - 除法
- (void) divBigInt:(XBigInt * _Nonnull)a;
- (void) divBigIntHex:(XHexString _Nonnull)aHex;
- (void) divBigIntDec:(NSString * _Nonnull)adec;

- (XBigInt * _Nonnull) divRemBigInt:(XBigInt * _Nonnull)a;
- (XBigInt * _Nonnull) divRemIntHex:(XHexString _Nonnull)aHex;
- (XBigInt * _Nonnull) divRemIntDec:(NSString * _Nonnull)adec;

- (XBigInt * _Nonnull) bigIntByDivBigInt:(XBigInt * _Nonnull)a;
- (XBigInt * _Nonnull) bigIntByDivBigIntHex:(XHexString _Nonnull)aHex;
- (XBigInt * _Nonnull) bigIntByDivBigIntDec:(NSString * _Nonnull)adec;

#pragma mark - 乘法
- (void) mulBigInt:(XBigInt * _Nonnull)a;
- (void) mulBigIntHex:(XHexString _Nonnull)aHex;
- (void) mulBigIntDec:(NSString * _Nonnull)adec;

- (XBigInt * _Nonnull) bigIntByMulBigInt:(XBigInt * _Nonnull)a;
- (XBigInt * _Nonnull) bigIntByMulBigIntHex:(XHexString _Nonnull)aHex;
- (XBigInt * _Nonnull) bigIntByMulBigIntDec:(NSString * _Nonnull)adec;

#pragma mark POW
- (void) powBigInt:(XBigInt * _Nonnull)a;
- (void) powBigIntHex:(XHexString _Nonnull)aHex;
- (void) powBigIntDec:(NSString * _Nonnull)adec;

- (XBigInt * _Nonnull) bigIntByPowBigInt:(XBigInt * _Nonnull)a;
- (XBigInt * _Nonnull) bigIntByPowBigIntHex:(XHexString _Nonnull)aHex;
- (XBigInt * _Nonnull) bigIntByPowBigIntDec:(NSString * _Nonnull)adec;

#pragma mark Mod
- (XBigInt * _Nonnull) bigIntByModBigInt:(XBigInt * _Nonnull)a;
- (XBigInt * _Nonnull) bigIntByModBigIntHex:(XHexString _Nonnull)aHex;
- (XBigInt * _Nonnull) bigIntByModBigIntDec:(NSString * _Nonnull)adec;

#pragma mark - 逻辑判断
- (bool) greaterThan:(XBigInt * _Nonnull)a;

- (bool) greaterThanOrEqual:(XBigInt * _Nonnull)a;

- (bool) lessThan:(XBigInt * _Nonnull)a;

- (bool) lessThanOrEqual:(XBigInt * _Nonnull)a;

- (bool) isEqual:(XBigInt * _Nonnull)a;
@end
