//
//  XProviderConfigure.m
//  xuper-sdk-oc-iOS
//
//  Created by apple on 2019/12/4.
//  Copyright © 2019 Martin.Ren. All rights reserved.
//

#import "XProviderConfigure.h"
#import "Xchain.pbrpc.h"

@implementation XProviderConfigure

+ (instancetype _Nonnull) configureWithHost:(NSString * _Nonnull)host {
    
    XProviderConfigure *configure = [[XProviderConfigure alloc] init];
    
    configure.host = host;
    
    return configure;
}

- (instancetype _Nonnull) init {
    
    self = [super init];
    
    self.useSecureConnections = NO;
    
    return self;
}

@end
