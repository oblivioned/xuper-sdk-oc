//
//  XError.h
//  xuper-sdk-oc-iOS
//
//  Created by apple on 2019/12/11.
//  Copyright © 2019 Martin.Ren. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XError : NSObject

+ (NSError * _Nonnull) xErrorAksFeeReject;

+ (NSError * _Nonnull) xErrorRequestTimeout;

+ (NSError * _Nonnull) xErrorTransactionContextNeedRebuild;

+ (NSError * _Nonnull) xErrorTransactionContextNeedPreExec;

+ (NSError * _Nonnull) xErrorTransactionContextNeedInitorSignature;

+ (NSError * _Nonnull) xErrorTransactionContextNeedAuthSignature;

+ (NSError * _Nonnull) xErrorTransactionContextRPCWithCode:(NSInteger)code;


@end
