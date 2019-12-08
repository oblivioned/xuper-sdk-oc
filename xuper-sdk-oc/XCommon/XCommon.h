//
//  XCommon.h
//  xuper-sdk-oc
//
//  Created by apple on 2019/11/29.
//  Copyright © 2019 Martin.Ren. All rights reserved.
//

#ifndef XCommon_h
#define XCommon_h

#import <Foundation/Foundation.h>

#define XUTXO_Version (1)

#define XSDKDefaultDescString @"transaction from xuper-sdk-oc 0.0.1"

#define XSDKExtern extern

typedef NSString* XCryptoTypeStringKey;

typedef NSString* XJsonString;

typedef NSString* XAddress;

typedef NSString* XAccount;

typedef NSString* XHexString;

typedef NSString* XContractName;

typedef NSData* XSignature;

@protocol XTransactionJsonEncodeable <NSObject>
/// 返回的对象必须可以使用NSJSONSerialization继续序列化！
- (id _Nullable) encodeToJsonObjectWithError:(NSError * _Nonnull * _Nullable)error;
@end

#endif /* XCommon_h */
