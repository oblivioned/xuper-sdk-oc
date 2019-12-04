//
//  XProviderProtocol.h
//  xuper-sdk-oc
//
//  Created by apple on 2019/12/3.
//  Copyright © 2019 Martin.Ren. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Xchain.pbrpc.h"
#import "XProviderConfigure.h"

@protocol XProviderProtocol

- (XProviderConfigure * _Nonnull) providerConfigure;

- (instancetype _Nonnull) initWithConfigure:(XProviderConfigure * _Nonnull)configure;

@end

