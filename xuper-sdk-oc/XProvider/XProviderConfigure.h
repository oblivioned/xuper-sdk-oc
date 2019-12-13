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

/// 使用安全的连接（目前在xuper 3.4中必须设置为NO，目前默认为：NO）原因是xuper node 暂时不支持安全连接形式，sdk中也暂时没有对安全连接的相关实现
@property (nonatomic, assign) bool useSecureConnections;

/// 远端节点的主机IP和端口（如：111.111.111.111:8888 )，不需要协议头
@property (nonatomic, strong) NSString * _Nonnull host;

/*!
 * 使用对应的原创主机重建一个连接提供者
 *
 * @param host 主机地址
 *
 * @result
 * XProviderConfigure 实例
 */
+ (instancetype _Nonnull) configureWithHost:(NSString * _Nonnull)host;

@end
