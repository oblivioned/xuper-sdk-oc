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
    BN_CTX *_ctx;
}

@end

@implementation XBigInt

- (void) dealloc {
    BN_free(self->_bn);
    BN_CTX_free(self->_ctx);
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

+ (instancetype _Nonnull) One {
    return [[XBigInt alloc] initWithUInt:1];
}

- (instancetype _Nonnull) init {
    
    self = [super init];
    
    self->_bn = BN_new();
    self->_ctx = BN_CTX_new();
    
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

- (instancetype _Nonnull) initWithData:( NSData * _Nonnull )data {
    
    self = [super init];
    
    self->_bn = BN_new();
    
    BN_bin2bn(data.bytes, data.length, self->_bn);
    
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


#pragma mark - 除法
/// int BN_div(BIGNUM *dv, BIGNUM *rem, const BIGNUM *a, const BIGNUM *d, BN_CTX *ctx)
/// d=a/b,r=a%b
- (void) divBigInt:(XBigInt * _Nonnull)a {
    BN_div(self->_bn, nil, self->_bn, a->_bn, self->_ctx);
}

- (void) divBigIntHex:(XHexString _Nonnull)aHex {
    XBigInt *a = [[XBigInt alloc] initWithHexString:aHex];
    return [self divBigInt:a];
}

- (void) divBigIntDec:(NSString * _Nonnull)adec {
    XBigInt *a = [[XBigInt alloc] initWithDecString:adec];
    return [self divBigInt:a];
}

- (XBigInt * _Nonnull) divRemBigInt:(XBigInt * _Nonnull)a {
    
    XBigInt *rem = XBigInt.Zero;
    
    BN_div(self->_bn, rem->_bn, self->_bn, a->_bn, rem->_ctx);
    
    return rem;
}

- (XBigInt * _Nonnull) divRemIntHex:(XHexString _Nonnull)aHex {
    XBigInt *a = [[XBigInt alloc] initWithHexString:aHex];
    return [self divRemIntHex:a];
}

- (XBigInt * _Nonnull) divRemIntDec:(NSString * _Nonnull)adec {
    XBigInt *a = [[XBigInt alloc] initWithDecString:adec];
    return [self divRemIntHex:a];
}

- (XBigInt * _Nonnull) bigIntByDivBigInt:(XBigInt * _Nonnull)a {
    
    XBigInt *r = XBigInt.Zero;
    
    BN_div(r->_bn, nil, self->_bn, a->_bn, r->_ctx);
    
    return r;
}

- (XBigInt * _Nonnull) bigIntByDivBigIntHex:(XHexString _Nonnull)aHex {
    XBigInt *a = [[XBigInt alloc] initWithHexString:aHex];
    return [self bigIntByDivBigInt:a];
}

- (XBigInt * _Nonnull) bigIntByDivBigIntDec:(NSString * _Nonnull)adec {
    XBigInt *a = [[XBigInt alloc] initWithDecString:adec];
    return [self bigIntByDivBigInt:a];
}

#pragma mark - 乘法
- (void) mulBigInt:(XBigInt * _Nonnull)a {
    BN_mul(self->_bn, self->_bn, a->_bn, self->_ctx);
}

- (void) mulBigIntHex:(XHexString _Nonnull)aHex {
    XBigInt *a = [[XBigInt alloc] initWithHexString:aHex];
    return [self mulBigInt:a];
}

- (void) mulBigIntDec:(NSString * _Nonnull)adec {
    XBigInt *a = [[XBigInt alloc] initWithDecString:adec];
    return [self mulBigInt:a];
}

- (XBigInt * _Nonnull) bigIntByMulBigInt:(XBigInt * _Nonnull)a {
    XBigInt *r = XBigInt.Zero;
    BN_mul(r->_bn, self->_bn, a->_bn, r->_ctx);
    return r;
}

- (XBigInt * _Nonnull) bigIntByMulBigIntHex:(XHexString _Nonnull)aHex {
    XBigInt *a = [[XBigInt alloc] initWithHexString:aHex];
    return [self bigIntByMulBigInt:a];
}

- (XBigInt * _Nonnull) bigIntByMulBigIntDec:(NSString * _Nonnull)adec {
    XBigInt *a = [[XBigInt alloc] initWithDecString:adec];
    return [self bigIntByMulBigInt:a];
}

#pragma mark - 幂
- (void) powBigInt:(XBigInt * _Nonnull)a {
    
    BN_MONT_CTX *mctx = BN_MONT_CTX_new();
    
    BN_MONT_CTX_init(mctx);
    
    BN_MONT_CTX_set(mctx, self->_bn, self->_ctx);
    
    BN_from_montgomery(self->_bn, a->_bn, mctx, self->_ctx);
    
    BN_MONT_CTX_free(mctx);
}

- (void) powBigIntHex:(XHexString _Nonnull)aHex {
    XBigInt *a = [[XBigInt alloc] initWithHexString:aHex];
    return [self powBigInt:a];
}

- (void) powBigIntDec:(NSString * _Nonnull)adec {
    XBigInt *a = [[XBigInt alloc] initWithDecString:adec];
    return [self powBigInt:a];
}

- (XBigInt * _Nonnull) bigIntByPowBigInt:(XBigInt * _Nonnull)a {
    
    XBigInt *r = XBigInt.Zero;
    
    BN_MONT_CTX *mctx = BN_MONT_CTX_new();
    
    BN_MONT_CTX_init(mctx);
    
    BN_MONT_CTX_set(mctx, self->_bn, self->_ctx);
    
    BN_from_montgomery(r->_bn, a->_bn, mctx, r->_ctx);
    
    BN_MONT_CTX_free(mctx);
    
    return r;
}

- (XBigInt * _Nonnull) bigIntByPowBigIntHex:(XHexString _Nonnull)aHex {
    XBigInt *a = [[XBigInt alloc] initWithHexString:aHex];
    return [self bigIntByPowBigInt:a];
}

- (XBigInt * _Nonnull) bigIntByPowBigIntDec:(NSString * _Nonnull)adec {
    XBigInt *a = [[XBigInt alloc] initWithDecString:adec];
    return [self bigIntByPowBigInt:a];
}

#pragma mark - 取余
- (XBigInt * _Nonnull) bigIntByModBigInt:(XBigInt * _Nonnull)a {
    
    XBigInt *rem = XBigInt.Zero;
    
    BN_div(nil, rem->_bn, self->_bn, a->_bn, rem->_ctx);

    return rem;
}

- (XBigInt * _Nonnull) bigIntByModBigIntHex:(XHexString _Nonnull)aHex {
    XBigInt *a = [[XBigInt alloc] initWithHexString:aHex];
    return [self bigIntByModBigInt:a];
}

- (XBigInt * _Nonnull) bigIntByModBigIntDec:(NSString * _Nonnull)adec {
    XBigInt *a = [[XBigInt alloc] initWithDecString:adec];
    return [self bigIntByModBigInt:a];
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
