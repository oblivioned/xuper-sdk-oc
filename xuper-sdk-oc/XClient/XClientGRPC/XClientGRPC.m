//
//  XClientGRPC.m
//  xuper-sdk-oc-iOS
//
//  Created by apple on 2019/12/4.
//  Copyright © 2019 Martin.Ren. All rights reserved.
//

#import "XClientGRPC.h"

#import "Xchain.pbrpc.h"

@interface XClientGRPC() {
    XProviderConfigure *_configure;
}

@property (nonatomic, strong) Xchain *xchainServices;

@end

@implementation XClientGRPC

- (XProviderConfigure * _Nonnull) providerConfigure {
    return self->_configure;
}

- (instancetype _Nonnull) initWithConfigure:(XProviderConfigure * _Nonnull)configure {
    
    self->_configure = configure;
    
    [GRPCCall useInsecureConnectionsForHost:self->_configure.host];
    
    self = [self initWithHost:self->_configure.host];
    
    return self;
}

@end
