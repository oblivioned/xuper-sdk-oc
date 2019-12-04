//
//  XClient.m
//  xuper-sdk-oc-iOS
//
//  Created by apple on 2019/12/4.
//  Copyright © 2019 Martin.Ren. All rights reserved.
//

#import "XClient.h"

@interface XClient()
@property (nonatomic, strong) id<XProviderProtocol> currProvider;
@end

@implementation XClient

+ (instancetype _Nonnull) createClientWithProvider:(id<XProviderProtocol> _Nonnull)provider {
    
    XClient *client = [[XClient alloc] init];
    
    client.currProvider = provider;
    
    return client;
}

- (instancetype _Nonnull) init {
    
    self = [super init];
    
    
    
    return self;
}

@end
