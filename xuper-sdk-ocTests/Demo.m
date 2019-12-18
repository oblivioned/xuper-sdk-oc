//
//  Demo.m
//  xuper-sdk-oc-Tests
//
//  Created by apple on 2019/12/18.
//  Copyright © 2019 Martin.Ren. All rights reserved.
//


#import "TestCommon.h"

@interface Demo : XCTestCase

@end

@implementation Demo

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

- (void)test_Demo_1_1 {
    
    // 创建支持ECDSA(P-256)模式的加解密Client
    // id<XCryptoClientProtocol> cryptoClient = [XCryptoFactory cryptoClientWithCryptoType:XCryptoTypeStringKeyECC];
    id<XCryptoClientProtocol> cryptoClient = [XCryptoFactory cryptoClientWithCryptoType:XCryptoTypeStringKeyDefault];
    
    id<XCryptoAccountProtocol> ak = [cryptoClient generateKey];
    
    NSLog(@"Addresss:%@", ak.address );
    NSLog(@"Pub:%@", ak.jsonPublicKey );
    NSLog(@"Priv:%@", ak.jsonPrivateKey);
}

- (void)test_Demo_1_2 {
    
    id<XCryptoClientProtocol> cryptoClient = [XCryptoFactory cryptoClientWithCryptoType:XCryptoTypeStringKeyDefault];
    
    // BIP39MnemonicLanguage_ChineseSimplified = BIP39MnemonicLanguage_Default,
    id<XBIP39AccountProtocol> bip39Ak = [cryptoClient createNewAccountWithMnemonicLanguage:BIP39MnemonicLanguage_Default
                                                                                  strength:BIP39MnemonicStrength_Midden
                                                                                  password:@"xuper-sdk-oc"
                                                                                     error:nil];
    
    NSLog(@"Mnemonic:%@", [bip39Ak.mnemonics componentsJoinedByString:@" "] );
    NSLog(@"Addresss:%@", bip39Ak.address );
    NSLog(@"Pub:%@", bip39Ak.jsonPublicKey );
    NSLog(@"Priv:%@", bip39Ak.jsonPrivateKey);
    
}

- (void)test_Demo_1_3 {
    
    id<XCryptoClientProtocol> cryptoClient = [XCryptoFactory cryptoClientWithCryptoType:XCryptoTypeStringKeyDefault];
    
    id<XBIP39AccountProtocol> bip39Ak = [cryptoClient retrieveAccountByMnemonic:@"登 层 擦 吃 抛 冻 曹 初 服 陶 梅 积 增 视 现 浓 干"
                                                                       password:@"xuper-sdk-oc"
                                                                       language:BIP39MnemonicLanguage_Default];
     
}

@end
