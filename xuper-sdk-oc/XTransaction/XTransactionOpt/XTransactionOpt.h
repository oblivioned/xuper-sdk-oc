//
//  XTransactionOpt.h
//  xuper-sdk-oc-iOS
//
//  Created by apple on 2019/12/6.
//  Copyright © 2019 Martin.Ren. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "XGlobalFlags.h"
#import "XCommon.h"
#import "XBigInt.h"
#import "XTransactionDesc.h"

@interface XTranctionToAccountData : NSObject

@property (nonatomic, copy) XAddress _Nonnull address;
@property (nonatomic, copy) XBigInt  * _Nonnull amount;
@property (nonatomic, assign) int64_t frozenHeight;

+ (instancetype _Nonnull) toAccountDataWithAddress:(XAddress _Nonnull)address amount:(XBigInt * _Nonnull)amount;
+ (instancetype _Nonnull) toAccountDataWithAddress:(XAddress _Nonnull)address amount:(XBigInt * _Nonnull)amount forzenHeight:(int64_t)forzenHeight;

@end

@interface XTransactionOpt : NSObject

/// 若指定则使用指定的global参数，否则使用默认的XGlobalFlags，若要修改默认的XGlobalFlags，可以使用 XGlobalFlags.appearance.xxx = xxx;
@property (nonatomic, strong)   XGlobalFlags *                      _Nonnull  globalFlags;
@property (nonatomic, copy)     XAddress                            _Nullable from;
@property (nonatomic, strong)   NSArray<XTranctionToAccountData*> * _Nullable to;
@property (nonatomic, copy)     XBigInt *                           _Nullable fee;
@property (nonatomic, strong)   XTransactionDesc *                  _Nullable desc;
@property (nonatomic, assign)   int64_t                                       frozenHeight;

@end
