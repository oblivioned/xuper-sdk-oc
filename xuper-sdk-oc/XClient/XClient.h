//
//  XClient.h
//  xuper-sdk-oc-iOS
//
//  Created by apple on 2019/12/4.
//  Copyright © 2019 Martin.Ren. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XProviderProtocol.h"

@protocol XClient <XProviderProtocol, Xchain, Xchain2> @end

@interface XClient : NSObject <XClient>

+ (id<XClient> _Nonnull) clientWithGRPCHost:(NSString * _Nonnull)host;

@end
