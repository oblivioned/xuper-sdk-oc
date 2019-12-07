//
//  XTransactionOpt+NewAccount.m
//  xuper-sdk-oc-iOS
//
//  Created by apple on 2019/12/7.
//  Copyright © 2019 Martin.Ren. All rights reserved.
//

#import "XTransactionOpt+NewAccount.h"
#import "XTransactionOpt.h"
#import "XBigInt.h"

@implementation XTransactionOpt(NewAccount)

+ (BOOL) vaildAccountName:(unsigned char [_Nullable 16])accountName {
    
    for ( int i = 0; i < 16; i++ ) {
        if ( !(accountName[i] >= '0' && accountName[i] <= '9') ) {
            return false;
        }
    }
    
    return true;
}

+ (instancetype _Nullable) newAccountOptWithAddress:(XAddress _Nonnull)address
                                                acl:(XTransactionACL * _Nonnull)acl
                                              error:(NSError * _Nonnull * _Nullable)error {
    
    NSTimeInterval t = [[NSDate date] timeIntervalSince1970];
        
    int64_t randomAccountNumber = (int64_t)(t * 1000000L);
        
    const char *pc = [NSString stringWithFormat:@"%lld", randomAccountNumber].UTF8String;
    
    unsigned char accountName[18] = {0};
    
    memcpy(accountName, pc, 18);
    
    return [self newAccountOptWithAddress:address accountName:accountName acl:acl error:error];
}

+ (instancetype _Nullable) newAccountOptWithAddress:(XAddress _Nonnull)address
                                        accountName:(unsigned char [_Nullable 16])accountName
                                                acl:(XTransactionACL * _Nonnull)acl
                                              error:(NSError * _Nonnull * _Nullable)error {
    
    if ( ![self vaildAccountName:accountName] ) {
        *error = [NSError errorWithDomain:@"invaild account name, account name expect continuous 16 number." code:-1 userInfo:nil];
        return nil;
    }
    
    XTransactionDescInvoke *desc = [[XTransactionDescInvoke alloc] init];
    
    desc.moduleName = XContractNameStandardModuleNameKernel;
    desc.methodName = @"NewAccount";
    desc.authRequires = @[address];
    desc.args = @{
        @"account_name": [[NSString alloc] initWithData:[NSData dataWithBytes:accountName length:16]
                                               encoding:NSUTF8StringEncoding],
        @"acl": acl.aclAuthRequireString,
    };
    
    XTransactionOpt *opt = [[XTransactionOpt alloc] init];
    
    /// 创建交易实际上是发送给自己的交易，有两个outputx，一个是对“$"地址，应该是手续费地址，一个是找零给自己,
    /// 关键的数据还是desc中提供的
    opt.from = address;
    opt.to = @[
        [XTranctionToAccountData toAccountDataWithAddress:address amount:XBigInt.Zero forzenHeight:0],
    ];
    opt.frozenHeight = 0;
    opt.desc = desc;
    
    return opt;
}

@end
