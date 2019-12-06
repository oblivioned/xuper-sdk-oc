//
//  XProviderConfigure.h
//  xuper-sdk-oc-iOS
//
//  Created by apple on 2019/12/4.
//  Copyright © 2019 Martin.Ren. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Header;

@interface XProviderConfigure : NSObject

/// 使用安全的连接（目前在xuper 3.4中必须设置为NO，目前默认为：NO）
/// 原因是xuper node 暂时不支持安全连接形式，sdk中也暂时没有对安全连接的相关实现
@property (nonatomic, assign) bool useSecureConnections;

@property (nonatomic, strong) NSString * _Nonnull host;

+ (instancetype _Nonnull) configureWithHost:(NSString * _Nonnull)host;

@end
