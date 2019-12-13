//
//  XTransactionOpt+Contracts.m
//  xuper-sdk-oc-iOS
//
//  Created by apple on 2019/12/8.
//  Copyright © 2019 Martin.Ren. All rights reserved.
//

#import "XTransactionOpt+Contracts.h"

@implementation XTransactionOpt(Contracts)

+ (instancetype _Nonnull) optWasmInvokeWithAddress:(NSString * _Nonnull)accountOrAddress
                                       authRequire:(NSArray<NSString*> * _Nullable)listOfAddressOrAccountOrNil
                                      contractName:(NSString * _Nonnull)contractName
                                        methodName:(NSString * _Nonnull)methodName
                                              args:(NSDictionary<NSString*, id> * _Nullable)args
                                      forzenHeight:(int64_t)forzenHeight {
    
    XTransactionDescInvoke *invokeDesc = [[XTransactionDescInvoke alloc] init];
    invokeDesc.moduleName = @"wasm";
    invokeDesc.contractName = contractName;
    invokeDesc.methodName = methodName;
    invokeDesc.args = args;
    
    if (listOfAddressOrAccountOrNil) {
        invokeDesc.authRequires = listOfAddressOrAccountOrNil;
    } else {
        invokeDesc.authRequires = @[accountOrAddress];
    }
    
    XTransactionOpt *opt = [[XTransactionOpt alloc] init];
    
    opt.from = accountOrAddress;
    
    opt.desc = invokeDesc;
    
    opt.frozenHeight = forzenHeight;
    
    return opt;
}

+ (instancetype _Nonnull) optWasmInvokeWithAddress:(NSString * _Nonnull)accountOrAddress
                                        invokeDesc:(XTransactionDescInvoke * _Nonnull)invoke
                                      forzenHeight:(int64_t)forzenHeight {
    
    XTransactionOpt *opt = [[XTransactionOpt alloc] init];
    
    opt.from = accountOrAddress;
    
    opt.desc = invoke;
    
    opt.frozenHeight = forzenHeight;
    
    return opt;
}

@end
