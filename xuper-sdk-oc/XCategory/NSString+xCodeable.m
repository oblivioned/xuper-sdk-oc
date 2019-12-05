//
//  NSString+xCodeable.m
//  xuper-sdk-oc
//
//  Created by apple on 2019/11/30.
//  Copyright © 2019 Martin.Ren. All rights reserved.
//

#import "NSString+xCodeable.h"
#import "NSData+xCodeable.h"
#import <openssl/bn.h>

@implementation NSString(xCodeable)

- (NSString * _Nonnull ) xBigNumberString {
    
    if (self.length <= 0) {
        return @"0";
    }
    
    BIGNUM *num = BN_new();
    
    BN_hex2bn(&num, self.UTF8String);
    
    NSString *ret = [[NSString alloc] initWithUTF8String:BN_bn2dec(num)];

    BN_free(num);
    
    return ret;
}

- (NSString * _Nonnull ) xBase64String {
    
    return [self dataUsingEncoding:NSUTF8StringEncoding].xBase64String;
    
}

@end
