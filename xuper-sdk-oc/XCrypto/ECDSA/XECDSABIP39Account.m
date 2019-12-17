//
//  XECDSABIP39Account.m
//  xuper-sdk-oc
//
//  Created by apple on 2019/12/17.
//  Copyright © 2019 Martin.Ren. All rights reserved.
//

#import "XECDSABIP39Account.h"
#import "XECDSAPrivKey.h"

@interface XECDSABIP39Account() {
    
    NSArray<NSString *> *m;
    
    BIP39MnemonicLanguage l;
}
@end

@implementation XECDSABIP39Account

+ (instancetype _Nullable) fromMnemonics:(NSString * _Nonnull)mnemonics pwd:(NSString * _Nullable)pwd language:(BIP39MnemonicLanguage)language {
    
    NSArray<NSString*> *mlist = [mnemonics componentsSeparatedByString:@" "];
    if ( mlist.count <= 0 ) {
        return nil;
    }
    
    /// 语言参数不正确
    if ( ![[XBIP39 getWordListByLanguage:language] containsObject:mlist.firstObject] ) {
        return nil;
    }
    
    NSData *seed = [XBIP39 seedFromMnemonics:mlist password:pwd];
    
    XECDSAPrivKey *pk = [XECDSAPrivKey generateKeyBySeed:seed];
    
    XECDSABIP39Account *acc = [[XECDSABIP39Account alloc] initWithPrivateKey:pk];
    
    acc->m = mlist;
    
    acc->l = language;
        
    return acc;
}

+ (instancetype _Nullable) fromMnemonics:(NSString * _Nonnull)mnemonics language:(BIP39MnemonicLanguage)language {
    return [self fromMnemonics:mnemonics pwd:nil language:language];
}

- (instancetype _Nullable) initWithPrivateKey:(XECDSAPrivKey * _Nonnull)p {
    return [super initWithPrivateKey:p];
}

- (BIP39MnemonicLanguage) language {
    return self->l;
}

- (NSArray<NSString *> * _Nullable)mnemonics {
    return self->m;
}

@end
