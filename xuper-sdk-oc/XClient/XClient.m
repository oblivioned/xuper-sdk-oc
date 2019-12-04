//
//  XClient.m
//  xuper-sdk-oc-iOS
//
//  Created by apple on 2019/12/4.
//  Copyright © 2019 Martin.Ren. All rights reserved.
//

#import "XClient.h"
#import "XClientGRPC.h"

@implementation XClient

+ (id<XClient> _Nonnull) clientWithGRPCHost:(NSString * _Nonnull)host {
    
    XProviderConfigure *clientConfigure = [XProviderConfigure configureWithHost:host];
    
    return [[XClientGRPC alloc] initWithConfigure:clientConfigure];
}

@end
