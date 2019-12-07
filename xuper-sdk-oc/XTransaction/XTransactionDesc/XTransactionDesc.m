//
//  XTransactionDesc.m
//  xuper-sdk-oc-iOS
//
//  Created by apple on 2019/12/6.
//  Copyright © 2019 Martin.Ren. All rights reserved.
//

#import "XTransactionDesc.h"

@implementation XTransactionDesc

- (NSData * _Nonnull)encodeToData {
    return [XSDKDefaultDescString dataUsingEncoding:NSUTF8StringEncoding];
}

+ (instancetype _Nullable)descWithString:(NSString * _Nullable)string {
    XTransactionDescString *desc = [[XTransactionDescString alloc] init];
    desc.string = string;
    return desc;
}

@end


@implementation XTransactionDescString

- (instancetype _Nonnull) init {
    
    self = [super init];
    self.string = XSDKDefaultDescString;
    return self;
}

- (NSData * _Nonnull)encodeToData {
    return [self.string dataUsingEncoding:NSUTF8StringEncoding];
}

@end
