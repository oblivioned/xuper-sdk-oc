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

- (Header * _Nonnull) randomHeader {
    
    Header *randHead = [[Header alloc] init];
    
    ///1.获取当前时间戳
    NSDate *nowDate = [NSDate now];
    
    NSTimeInterval timeInterval = [nowDate timeIntervalSince1970];
     
    NSMutableString *randLogid = [[NSMutableString alloc] initWithFormat:@"xuper-sdk-oc-logid-%lu", (unsigned long)(timeInterval * 1000)];
    
    [randLogid appendFormat:@"-%05ld", random() % 1000000];
    
    randHead.logid = randLogid;
    
    /** call rpc client address，客户端可以为空，节点一定要写自己的address */
    randHead.fromNode = @"";
    
    randHead.error = XChainErrorEnum_Success;
    
    return randHead;
}

@end
