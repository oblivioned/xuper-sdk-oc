//
//  XProviderProtocol.h
//  xuper-sdk-oc
//
//  Created by apple on 2019/12/3.
//  Copyright © 2019 Martin.Ren. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^XProviderSuccessBlock)(NSData * _Nonnull resposne);
typedef void(^XProviderFailedBlock)(NSError * _Nonnull error);

@protocol XProviderProtocol <NSObject>

- (NSData * _Nullable) syncSendRequest:(NSDate * _Nonnull)request onError:( NSError* _Nullable )error;

- (void) asyncSendRequest:(NSDate * _Nonnull)request onSuccess:(XProviderSuccessBlock _Nullable)success onFailed:(XProviderFailedBlock _Nullable)failed;

@end
