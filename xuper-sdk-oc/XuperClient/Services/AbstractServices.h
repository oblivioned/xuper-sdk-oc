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
#import "XTransactionACL.h"
#import "XBigInt.h"
#import "Xchain.pbobjc.h"
#import "XTransactionOpt.h"
#import "XTransactionDescInvoke.h"

typedef InternalBlock XBlock;

typedef void(^XServicesResponseHandle)(BOOL success, NSError * _Nullable error);
typedef void(^XServicesResponseHash)(XHexString _Nullable txhash, NSError * _Nullable error);
typedef void(^XServicesResponseBigInt)(XBigInt * _Nullable n, NSError * _Nullable error);
typedef void(^XServicesResponseContracts)(NSArray<ContractStatus*> * _Nullable contracts, NSError * _Nullable error);
typedef void(^XServicesResponseAccounts)(NSArray<XAccount> * _Nullable accounts, NSError * _Nullable error);
typedef void(^XServicesResponseCommonReply)(XAccount _Nullable account, XHexString _Nullable txhash, NSError * _Nullable error);
typedef void(^XServicesResponseTransactionACL)(XTransactionACL * _Nullable acl, NSError * _Nullable error);
typedef void(^XServicesResponseBlock)(XBlock * _Nullable block, NSError * _Nullable error);
typedef void(^XServicesResponseSignatureInfo)(SignatureInfo * _Nullable signInfo, NSError * _Nullable error);
typedef void(^XServicesResponseInvoke)(InvokeResponse * _Nullable response, NSError * _Nullable error);
typedef void(^XServicesResponseStatus)(SystemsStatus * _Nullable status, NSError * _Nullable error);

@interface AbstractServices : NSObject

@property (nonatomic, weak) XClient * _Nullable clientRef;

/// 链名，default: xuper
@property (nonatomic, copy) NSString * _Nonnull blockChainName;

- (instancetype _Nonnull) initWithClient:(id<XClient> _Nonnull)clientRef bcname:(NSString * _Nullable)blockChainName;

/// 请求没有问题，但是返回的对象为空
- (NSError * _Nonnull) errorRequestNoErrorResponseInvaild;

- (NSError * _Nonnull) errorResponseWithCode:(NSUInteger)code;

/// 预执行的方法，即不真实的在链上写入这笔交易，只是执行拿到结果类似 以太坊中的 “eth_call”
- (void) preExecTransaction:(Transaction * _Nonnull)tx handle:(XServicesResponseInvoke _Nonnull)handle;

- (void) preExecInvokesWithInitor:(NSString * _Nonnull)initor invokes:(NSArray<InvokeRequest*> * _Nonnull)invokes authrequires:(NSArray<NSString*>* _Nullable)authrequires handle:(XServicesResponseInvoke _Nonnull)handle;

- (void) preExecOpt:(XTransactionOpt * _Nonnull)opt handle:(XServicesResponseInvoke _Nonnull)handle;

@end
