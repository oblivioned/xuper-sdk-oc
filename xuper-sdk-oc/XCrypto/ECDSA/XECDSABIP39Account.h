//
//  XECDSABIP39Account.h
//  xuper-sdk-oc
//
//  Created by apple on 2019/12/17.
//  Copyright © 2019 Martin.Ren. All rights reserved.
//

#import "XECDSAAccount.h"
#import "BIP39.h"

@interface XECDSABIP39Account : XECDSAAccount <XBIP39AccountProtocol>

+ (instancetype _Nullable) fromMnemonics:(NSString * _Nonnull)mnemonics language:(BIP39MnemonicLanguage)language;

+ (instancetype _Nullable) fromMnemonics:(NSString * _Nonnull)mnemonics pwd:(NSString * _Nullable)pwd language:(BIP39MnemonicLanguage)language;

@end
