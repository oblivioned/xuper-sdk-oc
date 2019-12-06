//
//  NSMutableData+xCodeable.h
//  xuper-sdk-oc-iOS
//
//  Created by apple on 2019/12/4.
//  Copyright © 2019 Martin.Ren. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableData(xCodeable)

- (void) appendUInt32:(uint32_t)n;
- (void) appendInt32:(int32_t)n;

- (void) appendUint64:(uint64_t)n;
- (void) appendInt64:(int64_t)n;

- (void) appendString:(NSString * _Nullable)s;
- (void) appendBool:(BOOL)b;

@end

