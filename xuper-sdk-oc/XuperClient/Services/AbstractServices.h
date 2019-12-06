//
//  AbstractServices.h
//  xuper-sdk-oc-iOS
//
//  Created by apple on 2019/12/6.
//  Copyright © 2019 Martin.Ren. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XClient.h"
#import "XCommon.h"
#import "Transaction+SDKExtension.h"
#import "GPBMessage+RandomHeader.h"
#import "XBigInt.h"

typedef void(^XServicesResponseBigInt)(XBigInt * _Nullable n, NSError * _Nullable error);
typedef void(^XServicesResponseContracts)(NSArray<ContractStatus*> * _Nullable contracts, NSError * _Nullable error);
typedef void(^XServicesResponseAccounts)(NSArray<XAccount> * _Nullable accounts, NSError * _Nullable error);

@interface AbstractServices : NSObject

@property (nonatomic, weak) XClient * _Nullable clientRef;

/// 链名，default: xuper
@property (nonatomic, copy) NSString * _Nonnull blockChainName;

- (instancetype _Nonnull) initWithClient:(id<XClient> _Nonnull)clientRef bcname:(NSString * _Nullable)blockChainName;

/// 请求没有问题，但是返回的对象为空
- (NSError * _Nonnull) errorRequestNoErrorResponseInvaild;

- (NSError * _Nonnull) errorResponseWithCode:(NSUInteger)code;

@end
