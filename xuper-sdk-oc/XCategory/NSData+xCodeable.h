//
//  NSData+HexString.h
//  xuper-sdk-oc
//
//  Created by apple on 2019/11/29.
//  Copyright © 2019 Martin.Ren. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData(xCodeable)

- (NSString * _Nonnull ) xString;
- (NSString * _Nonnull ) xBigNumberString;
- (NSString * _Nonnull ) xHexString;
- (NSString * _Nonnull ) xBase64String;
- (NSString * _Nonnull ) xBase58String;
- (NSString * _Nonnull ) xJsonString;
- (NSString * _Nullable) xSHA256HexString;
- (NSData   * _Nullable) xSHA256Data;

- (NSData   * _Nonnull ) xBase64Data;

+ (NSData * _Nullable) xFromBase58String:(NSString * _Nonnull)base58string;
+ (NSData * _Nullable) xFromBase64String:(NSString * _Nonnull)base64string;
+ (NSData * _Nullable) xFromHexString:(NSString * _Nonnull)base58string;

@end
