//
//  AbstractServices.m
//  xuper-sdk-oc-iOS
//
//  Created by apple on 2019/12/6.
//  Copyright © 2019 Martin.Ren. All rights reserved.
//

#import "AbstractServices.h"

@implementation AbstractServices

- (instancetype _Nonnull) initWithClient:(id<XClient> _Nonnull)clientRef bcname:(NSString * _Nullable)blockChainName {
    
    self = [super init];
    
    self.clientRef = clientRef;
    
    if (blockChainName) {
        self.blockChainName = blockChainName;
    } else {
        self.blockChainName = @"xuper";
    }
    
    return self;
}

- (NSError * _Nonnull) errorResponseWithCode:(NSUInteger)code {
    return [NSError errorWithDomain:@"response invalid" code:code userInfo:nil];
}

- (NSError * _Nonnull) errorRequestNoErrorResponseInvaild {
    return [NSError errorWithDomain:@"request no error, but response invalid." code:-1 userInfo:nil];
}
@end
