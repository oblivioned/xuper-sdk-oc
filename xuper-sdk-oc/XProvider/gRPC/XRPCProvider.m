//
//  XRPCProvider.m
//  xuper-sdk-oc
//
//  Created by apple on 2019/12/3.
//  Copyright © 2019 Martin.Ren. All rights reserved.
//

#import "XRPCProvider.h"

#import <GRPCClient/GRPCCall.h>
#import <ProtoRPC/ProtoMethod.h>
#import <RxLibrary/GRXWriteable.h>
#import <RxLibrary/GRXWriter+Immediate.h>

#import "Xchain.pbrpc.h"

@implementation XRPCProvider

- (void)asyncSendRequest:(NSDate * _Nonnull)request onSuccess:(XProviderSuccessBlock _Nullable)success onFailed:(XProviderFailedBlock _Nullable)failed {
    
    Xchain *xchainServices = [[Xchain alloc] initWithHost:@""];

    
    return ;
}

- (NSData * _Nullable)syncSendRequest:(NSDate * _Nonnull)request onError:(NSError * _Nullable)error {
    return nil;
}

@end
