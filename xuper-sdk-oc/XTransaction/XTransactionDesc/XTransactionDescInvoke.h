//
//  XTransactionDescContracts.h
//  xuper-sdk-oc-iOS
//
//  Created by apple on 2019/12/7.
//  Copyright © 2019 Martin.Ren. All rights reserved.
//

#import "XTransactionDesc.h"
#import "XTransactionACL.h"
#import "Xchain.pbobjc.h"

typedef NSString* XContractNameStandardModuleName;

///xkernel
XSDKExtern XContractNameStandardModuleName const _Nonnull XContractNameStandardModuleNameKernel;

@interface XTransactionDescInvoke : XTransactionDesc

@property (nonatomic, copy) NSString * _Nullable moduleName;
@property (nonatomic, copy) XContractName _Nonnull contractName;
@property (nonatomic, copy) NSString * _Nonnull methodName;
@property (nonatomic, strong) NSDictionary<NSString*, id> * _Nonnull args;

/// 获取GRPC所需要的invokeRequest
@property (nonatomic, readonly) InvokeRequest * _Nonnull invokeRequest;

- (NSData * _Nonnull)encodeToDataWithError:(NSError * _Nonnull * _Nullable)error;



@end
