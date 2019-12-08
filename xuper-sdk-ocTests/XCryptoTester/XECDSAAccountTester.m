//
//  XECDSAAccount_ocTests.m
//  xuper-sdk-ocTests
//
//  Created by apple on 2019/11/30.
//  Copyright © 2019 Martin.Ren. All rights reserved.
//

#import <XCTest/XCTest.h>

#import <xuper_sdk_oc_iOS/xuper_sdk_oc_iOS.h>

@interface XECDSAAccountTester : XCTestCase

@property (nonatomic, strong) XECDSAClient *client;
@property (nonatomic, strong) id<XCryptoAccountProtocol> account;

@property (nonatomic, strong) NSArray<XAddress> *xuperAddress;
@property (nonatomic, strong) NSArray<NSDictionary*> *xuperKeys;

@property (nonatomic, strong) NSData *testRawMessage;

@end

@implementation XECDSAAccountTester

- (void)setUp {
    
    self.testRawMessage = [NSData dataWithBytes:"xuper-sdk-oc" length:12];
    
    self.xuperAddress = @[
        @"dpzuVdosQrF2kmzumhVeFQZa1aYcdgFpN",
        @"WNWk3ekXeM5M2232dY2uCJmEqWhfQiDYT",
        @"akf7qunmeaqb51Wu418d6TyPKp4jdLdpV",
    ];
    
    self.xuperKeys = @[
        @{
            @"Curvname":@"P-256",
            @"X":@"74695617477160058757747208220371236837474210247114418775262229497812962582435",
            @"Y":@"51348715319124770392993866417088542497927816017012182211244120852620959209571",
            @"D":@"29079635126530934056640915735344231956621504557963207107451663058887647996601"
        },
        @{
            @"Curvname":@"P-256",
            @"X":@"38583161743450819602965472047899931736724287060636876073116809140664442044200",
            @"Y":@"73385020193072990307254305974695788922719491565637982722155178511113463088980",
            @"D":@"98698032903818677365237388430412623738975596999573887926929830968230132692775"
        },
        @{
            @"Curvname":@"P-256",
            @"X":@"82701086955329320728418181640262300520017105933207363210165513352476444381539",
            @"Y":@"23833609129887414146586156109953595099225120577035152268521694007099206660741",
            @"D":@"57537645914107818014162200570451409375770015156750200591470574847931973776404"
        },
    ];
    
    self.client = [[XECDSAClient alloc] init];
    
    self.account = [self.client generateKey];
    
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)test_Base58 {
    
    NSString *base58Encode = [self.testRawMessage xBase58String];
    
    NSData *base58Decode = [NSData xFromBase58String:base58Encode];
    
    NSString *base58DecodeString = [[NSString alloc] initWithData:base58Decode encoding:NSUTF8StringEncoding];
    
    XCTAssertTrue( [base58DecodeString isEqualToString:@"xuper-sdk-oc"] );
}

- (void)test_GenerateKey {
    
    XCTAssertTrue(self.account.address && self.account.address.length == 33, @"no address or invaild address");
    XCTAssertTrue(self.account.jsonPrivateKey && self.account.jsonPrivateKey.length > 0, @"no jsonPublicKey");
    XCTAssertTrue(self.account.jsonPublicKey && self.account.jsonPublicKey.length > 0, @"no jsonPublicKey");
    
    printf("Address:%s\n", self.account.address.UTF8String);
    printf("Private:%s\n", self.account.jsonPrivateKey.UTF8String);
    printf("Publick:%s\n", self.account.jsonPublicKey.UTF8String);
    
}

/// 测试生成的address 和 xuper的是否一致
/// 1.使用X,Y 还原一个私钥(XECDSAPrivKey)， X，Y来自xchain-cli生成
/// 2.使用私钥创建XECDSAAccount
/// 3.对比地址
- (void)test_Address {
    
    for ( int i = 0; i < self.xuperKeys.count; i++) {
        
        XECDSAPrivKey *pk = [XECDSAPrivKey fromExportedDictionary:self.xuperKeys[i]];
        
        XECDSAAccount *tAccount = [XECDSAAccount fromPrivateKey:pk];
        
        XCTAssertTrue( [tAccount.address isEqualToString:self.xuperAddress[i]] );
    }
    
}

/// 签名和验证测试
/// 1.使用测试地址1，签名后验证（预期结果应该为验证通过）
/// 2.使用相同地址，不同内容验证（预期结果应该为失败）
/// 3.使用相同地址，相同内容验证（与其结果应该为成功）
/// 4.使用不同地址，相同结果验证（与其应该为失败）
- (void)test_SignMessageWithXuperDemomKey {
    
    NSError *error = NULL;
    
    XECDSAPrivKey *pk = [XECDSAPrivKey fromExportedDictionary:self.xuperKeys[0]];
    
    XECDSAAccount *demoAcc0 = [XECDSAAccount fromPrivateKey:pk];
    
    /// test case 1
    /// 消息签名
    XSignature sig = [self.client signRawMessage:self.testRawMessage keypair:demoAcc0 error:&error];
    XCTAssertNil(error);
    XCTAssertNotNil(sig);
    /// 消息验证
    XCTAssertTrue([self.client verifyWithPublicKey:demoAcc0.publicKey signature:sig rawMessage:self.testRawMessage error:&error]);
    XCTAssertNil(error);
    
    
    /// test case 2
    /// 错误的签名测试
    XSignature wrongSig1 = [NSData xFromBase64String:@"MEYCIQCKlP0zelxUEuway8O/SxT8bkp9CUAlZDStYHtPqR4rHgIhAOvakSMvSw46g85zDsVFCGYIMse+qNox5ExQFmBZiWAH"];
    XCTAssertFalse([self.client verifyWithPublicKey:demoAcc0.publicKey signature:wrongSig1 rawMessage:self.testRawMessage error:&error]);
    
    XSignature wrongSig2 = [NSData xFromBase64String:@"MEQCIFjTvh08YbrzqzqJKS+FQ4BajLC+hKNHlFSFRrk0+YxgAiBHg3eewoqUkc6R5+xAiP2m1WOY2pyJTThH5XehiZFIpA=="];
    XCTAssertFalse([self.client verifyWithPublicKey:demoAcc0.publicKey signature:wrongSig2 rawMessage:self.testRawMessage error:&error]);
    
    
    
    /// test case 3, 签名均从golang版本的源码中计算得到，原文与本测试用例一致
    XSignature rightSig1 = [NSData xFromBase64String:@"MEQCID7lLidZFBVHvqdHfK0REJaZ8wj/D/tUbI4rUxHXItP/AiAPIhcmW6/dCDAlC4MAN5v+K61NDfZfqRaPCt917h/WPA=="];
    XCTAssertTrue([self.client verifyWithPublicKey:demoAcc0.publicKey signature:rightSig1 rawMessage:self.testRawMessage error:&error]);
    
    XSignature rightSig2 = [NSData xFromBase64String:@"MEUCIHn0Fh9Hh5MPNhDpVDmouZ80HzD8rqELBD4k03hhvaAsAiEA8snkuLYsvA7fryro1jF/Jg6s3IGSlnRKnyGXPv2NxUM="];
    XCTAssertTrue([self.client verifyWithPublicKey:demoAcc0.publicKey signature:rightSig2 rawMessage:self.testRawMessage error:&error]);
    
    
    
    /// test case 4,
    /// sin 使用的是2号地址(即 WNWk3ekXeM5M2232dY2uCJmEqWhfQiDYT) 签名
    XSignature otherSig = [NSData xFromBase64String:@"MEQCIBto6u3Tq107H7RQ8V3Qu5O/d39cUOj1KpLYXj2h+N1zAiAyAHdqkvWnfOYLoC5eri96jhaDUdP0CtdL/4Zh6ZFyKA=="];
    XCTAssertFalse([self.client verifyWithPublicKey:demoAcc0.publicKey signature:otherSig rawMessage:self.testRawMessage error:&error]);
}

/// 签名和验证测试，使用sdk创建公私钥对，就行签名和验证
- (void)test_SignMessageWithGenerateKey {
    
    NSError *error = NULL;
    
    /// 消息签名
    XSignature sig = [self.client signRawMessage:self.testRawMessage keypair:self.account error:&error];
    XCTAssertNil(error);
    XCTAssertNotNil(sig);
    
    /// 消息验证
    XCTAssertTrue([self.client verifyWithPublicKey:self.account.publicKey signature:sig rawMessage:self.testRawMessage error:&error]);
    XCTAssertNil(error);
}

/// 测试地址格式验证的几个方法
- (void)test_AddressCheckCode {
    
    uint32_t version = 0;
    NSError *error = NULL;
    
    XCTAssertTrue([self.client checkFormatWithAddress:self.account.address version:&version error:&error]);
    XCTAssertNil(error);
}

@end
