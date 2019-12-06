//
//  XTransactionOpt.m
//  xuper-sdk-oc-iOS
//
//  Created by apple on 2019/12/6.
//  Copyright © 2019 Martin.Ren. All rights reserved.
//

#import "XTransactionOpt.h"

@implementation XTranctionToAccountData

+ (instancetype _Nonnull) toAccountDataWithAddress:(XAddress _Nonnull)address amount:(XBigInt * _Nonnull)amount {
    
    XTranctionToAccountData *data = [[XTranctionToAccountData alloc] init];
    
    data.address = address;
    data.amount = amount;
    data.frozenHeight = 0;
    
    return data;
}

+ (instancetype _Nonnull) toAccountDataWithAddress:(XAddress _Nonnull)address amount:(XBigInt * _Nonnull)amount forzenHeight:(int64_t)forzenHeight {
    
    XTranctionToAccountData *data = [[XTranctionToAccountData alloc] init];
    
    data.address = address;
    data.amount = amount;
    data.frozenHeight = forzenHeight;
    
    return data;
}

@end

@implementation XTransactionOpt

/// 如果用户有指定globalFlags对象则使用用户的对象，否则使用默认的GlobalFlags
- (XGlobalFlags *)globalFlags {
    
    if ( !_globalFlags ) {
        return XGlobalFlags.appearance;
    }
    
    return _globalFlags;
}

- (instancetype _Nonnull) init {
    
    self = [super init];

    return self;
}

@end
