//
//  XError.m
//  xuper-sdk-oc-iOS
//
//  Created by apple on 2019/12/11.
//  Copyright © 2019 Martin.Ren. All rights reserved.
//

#import "XError.h"

#define XErrorDefine(errCode)\
    static NSError *error;\
    static dispatch_once_t onceToken;\
    dispatch_once(&onceToken, ^{\
        error = [NSError errorWithDomain:[NSString stringWithUTF8String:__FUNCTION__] code:errCode userInfo:nil];\
    });\
return error;

@implementation XError

+ (NSError * _Nonnull) xErrorAksFeeReject { XErrorDefine(-1) }
    
+ (NSError * _Nonnull) xErrorRequestTimeout { XErrorDefine(-2) }

+ (NSError * _Nonnull) xErrorTransactionContextNeedRebuild { XErrorDefine(-3) }

+ (NSError * _Nonnull) xErrorTransactionContextNeedPreExec { XErrorDefine(-4) }

+ (NSError * _Nonnull) xErrorTransactionContextNeedInitorSignature { XErrorDefine(-5) }

+ (NSError * _Nonnull) xErrorTransactionContextNeedAuthSignature { XErrorDefine(-5) }

+ (NSError * _Nonnull) xErrorTransactionContextRPCWithCode:(NSInteger)code { XErrorDefine(code) }
@end
