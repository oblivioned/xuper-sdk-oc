//
//  GPBMessage+RandomHeader.h
//  xuper-sdk-oc-iOS
//
//  Created by apple on 2019/12/6.
//  Copyright © 2019 Martin.Ren. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Xchain.pbobjc.h"

@interface GPBMessage(RandomHeader)

/*!
 * 创建一个请求使用的Header，其中主要是约束了logid的格式，注意：本方法只会返回一个Header对象，不会直接设置如message，
 * 需要手动设置，如 message.header = randomwHeader;
 *
 * @result
 * Header对象
*/
+ (Header * _Nonnull) getRandomHeader;

@end
