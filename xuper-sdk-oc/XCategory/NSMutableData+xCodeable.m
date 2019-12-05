//
//  NSMutableData+xCodeable.m
//  xuper-sdk-oc-iOS
//
//  Created by apple on 2019/12/4.
//  Copyright © 2019 Martin.Ren. All rights reserved.
//

#import "NSMutableData+xCodeable.h"

@implementation NSMutableData(xCodeable)

- (void) appendUInt32:(uint32_t)n {
    [self appendBytes:&n length:sizeof(uint32_t)];
}

- (void) appendInt32:(int32_t)n {
    [self appendBytes:&n length:sizeof(int32_t)];
}

- (void) appendUint64:(uint64_t)n {
    [self appendBytes:&n length:sizeof(uint64_t)];
}

- (void) appendInt64:(int64_t)n {
    [self appendBytes:&n length:sizeof(int64_t)];
}

- (void) appendString:(NSString * _Nullable)s {
    
    if (!s) {
        [self appendBytes:"null" length:4];
    } else {
        [self appendBytes:s.UTF8String length:s.length];
    }
    
}

- (void) appendBool:(BOOL)b {
    if (b) {
        [self appendString:@"true"];
    } else {
        [self appendString:@"false"];
    }
}

@end
