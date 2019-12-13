//
//  XBigInt.m
//  xuper-sdk-oc-iOS
//
//  Created by apple on 2019/12/6.
//  Copyright © 2019 Martin.Ren. All rights reserved.
//

#import "XBigInt.h"
#import "NSData+xCodeable.h"

@interface XBigInt() {
    BIGNUM *_bn;
}

@end

@implementation XBigInt

- (void) dealloc {
    BN_free(self->_bn);
}

- (id)copyWithZone:(nullable NSZone *)zone {
    
    return [[XBigInt alloc] initWithHexString:self.hexString];
    
    /// ？为什么拷贝以后还是0
    //XBigInt *copy = [[XBigInt alloc] init];
    ///BN_copy(self->_bn, copy->_bn);
    ///return copy;
}

+ (instancetype _Nonnull) Zero {
    return [[XBigInt alloc] init];
}

- (instancetype _Nonnull) init {
    self = [super init];
    
    self->_bn = BN_new();
    
    return self;
}
/**
 * 使用十六进制字符串生成XBigInt对象，不区分大小写
 * \param  hexString 0xFF, FF, 0xff, ff ...
 * \return XBigInt*
*/
- (instancetype _Nonnull) initWithHexString:( XHexString _Nonnull )hexString {
    
    self = [super init];
    
    self->_bn = BN_new();
    
    if ( [hexString.lowercaseString hasPrefix:@"0x"] ) {
        
        NSAssert(BN_hex2bn(&self->_bn, [hexString substringFromIndex:2].UTF8String), @"invaild XBigInt hexstring.");
        
    } else {
        
        NSAssert(BN_hex2bn(&self->_bn, hexString.UTF8String), @"invaild XBigInt hexstring.");
    }
    
    return self;
}

/**
 * 使用十进制字符串生成XBigInt对象
 * \param  decString 如"12381293719827389172893718923"
 * \return XBigInt*
*/
- (instancetype _Nonnull) initWithDecString:( NSString * _Nonnull )decString {
    
    self = [super init];
    
    self->_bn = BN_new();
    
    NSAssert(BN_dec2bn(&self->_bn, decString.UTF8String), @"invaild XBigInt decstring.");
    
    return self;
}

- (instancetype _Nonnull) initWithUInt:(NSUInteger)n {
    
    self = [self initWithDecString:[NSString stringWithFormat:@"%lld", n]];
    
    return self;
}

/**
 * 获取十六进制表示的数字
*/
- (NSString * _Nonnull) hexString {
    char *p = BN_bn2hex(self->_bn);
    NSString *r = [[NSString alloc] initWithUTF8String:p];
    free(p);p = NULL;
    return r;
}

/**
 * 获取十进制表示的数字
*/
- (NSString * _Nonnull) decString {
    char *p = BN_bn2dec(self->_bn);
    NSString *r = [[NSString alloc] initWithUTF8String:p];
    free(p);p = NULL;
    return r;
}

/**
 * 获取base64表达的数字
*/
- (NSString * _Nonnull) base64String {
    return self.data.xBase64String;
}

/**
 * 获取二进制，一般用于数据传输前
 * \return NSData * _Nonnull
*/
- (NSData * _Nonnull) data {
    
    int len = BN_num_bytes(self->_bn);
    
    unsigned char *p = malloc(len);
    
    if ( !BN_bn2bin(self->_bn, p) ) {
        return [NSData data];
    }
    
    NSData *r = [NSData dataWithBytes:p length:len];
    free(p);p=NULL;
    
    return r;
}

#pragma mark - 加法
- (void) addBigInt:(XBigInt * _Nonnull)a {
    BN_add(self->_bn, self->_bn, a->_bn);
}

- (void) addBigIntHex:(XHexString _Nonnull)aHex {
    XBigInt *a = [[XBigInt alloc] initWithHexString:aHex];
    return [self addBigInt:a];
}

- (void) addBigIntDec:(NSString * _Nonnull)aHex {
    XBigInt *a = [[XBigInt alloc] initWithDecString:aHex];
    return [self addBigInt:a];
}

- (XBigInt * _Nonnull) bigIntByAddBigInt:(XBigInt * _Nonnull)a {
    XBigInt *r = XBigInt.Zero;
    BN_add(r->_bn, self->_bn, a->_bn);
    return r;
}

- (XBigInt * _Nonnull) bigIntByAddBigIntHex:(XHexString _Nonnull)aHex {
    XBigInt *a = [[XBigInt alloc] initWithHexString:aHex];
    return [self bigIntByAddBigInt:a];
}

- (XBigInt * _Nonnull) bigIntByAddBigIntDec:(NSString * _Nonnull)adec {
    XBigInt *a = [[XBigInt alloc] initWithDecString:adec];
    return [self bigIntByAddBigInt:a];
}

#pragma mark - 减法
- (void) subBigInt:(XBigInt * _Nonnull)a {
    BN_sub(self->_bn, self->_bn, a->_bn);
}

- (void) subBigIntHex:(XHexString _Nonnull)aHex {
    XBigInt *a = [[XBigInt alloc] initWithHexString:aHex];
    return [self subBigInt:a];
}

- (void) subBigIntDec:(NSString * _Nonnull)adec {
    XBigInt *a = [[XBigInt alloc] initWithDecString:adec];
    return [self subBigInt:a];
}

- (XBigInt * _Nonnull) bigIntBySubBigInt:(XBigInt * _Nonnull)a {
    XBigInt *r = XBigInt.Zero;
    BN_sub(r->_bn, self->_bn, a->_bn);
    return r;
}

- (XBigInt * _Nonnull) bigIntBySubBigIntHex:(XHexString _Nonnull)aHex {
    XBigInt *a = [[XBigInt alloc] initWithHexString:aHex];
    return [self bigIntBySubBigInt:a];
}

- (XBigInt * _Nonnull) bigIntBySubBigIntDec:(NSString * _Nonnull)adec {
    XBigInt *a = [[XBigInt alloc] initWithDecString:adec];
    return [self bigIntBySubBigInt:a];
}


#pragma mark - 逻辑判断
- (bool) greaterThan:(XBigInt * _Nonnull)a {
    return BN_cmp(self->_bn, a->_bn) > 0;
}

- (bool) greaterThanOrEqual:(XBigInt * _Nonnull)a {
    return BN_cmp(self->_bn, a->_bn) >= 0;
}

- (bool) lessThan:(XBigInt * _Nonnull)a {
    return BN_cmp(self->_bn, a->_bn) < 0;
}

- (bool) lessThanOrEqual:(XBigInt * _Nonnull)a {
    return BN_cmp(self->_bn, a->_bn) <= 0;
}

- (bool) isEqual:(XBigInt * _Nonnull)a {
    return BN_cmp(self->_bn, a->_bn) == 0;
}

- (NSString *) debugDescription {
    return self.decString;
}

@end
