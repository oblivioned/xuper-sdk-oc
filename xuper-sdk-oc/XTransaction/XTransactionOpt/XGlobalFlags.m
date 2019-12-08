//
//  XTransactionGlobalFlags.m
//  xuper-sdk-oc-iOS
//
//  Created by apple on 2019/12/6.
//  Copyright © 2019 Martin.Ren. All rights reserved.
//

#import "XGlobalFlags.h"

@implementation XGlobalFlags

+ (instancetype _Nonnull) appearance {
    
    static dispatch_once_t onceToken;
    static XGlobalFlags * __static_global_flags = NULL;
    dispatch_once(&onceToken, ^{
        __static_global_flags = [[XGlobalFlags alloc] init];
    });
    
    return __static_global_flags;
}

- (instancetype _Nonnull) init {
    
    self = [super init];
    
    self.blockchainName = @"xuper";
    self.cryptoType = XCryptoTypeStringKeyDefault;
    self.keyPath = @"";
    
    return self;
}

@end
