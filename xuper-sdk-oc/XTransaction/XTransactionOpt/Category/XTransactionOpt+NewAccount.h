//
//  XTransactionOpt+NewAccount.h
//  xuper-sdk-oc-iOS
//
//  Created by apple on 2019/12/7.
//  Copyright © 2019 Martin.Ren. All rights reserved.
//

#import "XTransactionOpt.h"
#import "XTransactionDescInvoke.h"
#import "XTransactionACL.h"

@interface XTransactionOpt(NewAccount)

+ (instancetype _Nullable) newAccountOptWithAddress:(XAddress _Nonnull)address
                                                acl:(XTransactionACL * _Nonnull)acl
                                              error:(NSError * _Nonnull * _Nullable)error;


+ (instancetype _Nullable) newAccountOptWithAddress:(XAddress _Nonnull)address
                                        accountName:(unsigned char [_Nullable 16])accountName
                                                acl:(XTransactionACL * _Nonnull)acl
                                              error:(NSError * _Nonnull * _Nullable)error;

@end
