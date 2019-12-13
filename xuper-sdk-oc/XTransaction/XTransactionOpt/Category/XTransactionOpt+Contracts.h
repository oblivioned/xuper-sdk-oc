//
//  XTransactionOpt+Contracts.h
//  xuper-sdk-oc-iOS
//
//  Created by apple on 2019/12/8.
//  Copyright © 2019 Martin.Ren. All rights reserved.
//

#import "XTransactionOpt.h"
#import "XTransactionDescInvoke.h"
#import "XTransactionACL.h"

@interface XTransactionOpt(Contracts)

+ (instancetype _Nonnull) optWasmInvokeWithAddress:(NSString * _Nonnull)accountOrAddress
                                       authRequire:(NSArray<NSString*> * _Nullable)listOfAddressOrAccountOrNil
                                      contractName:(NSString * _Nonnull)contractName
                                        methodName:(NSString * _Nonnull)methodName
                                              args:(NSDictionary<NSString*, id> * _Nullable)args
                                      forzenHeight:(int64_t)forzenHeight;

+ (instancetype _Nonnull) optWasmInvokeWithAddress:(NSString * _Nonnull)accountOrAddress
                                        invokeDesc:(XTransactionDescInvoke * _Nonnull)invoke
                                      forzenHeight:(int64_t)forzenHeight;

@end
