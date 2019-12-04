//
//  XClient.h
//  xuper-sdk-oc-iOS
//
//  Created by apple on 2019/12/4.
//  Copyright © 2019 Martin.Ren. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "XProviderProtocol.h"

@interface XClient : NSObject

+ (instancetype _Nonnull) createClientWithProvider:(id<XProviderProtocol> _Nonnull)provider;

@end

