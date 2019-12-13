//
//  TestCommon.m
//  xuper-sdk-oc-iOSTests
//
//  Created by apple on 2019/12/11.
//  Copyright © 2019 Martin.Ren. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "TestCommon.h"

@implementation T

+ (XuperClient *) xuperClient {
    
    static XuperClient *client;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        client = [XuperClient newClientWithHost:@"127.0.0.1:37101" blockChainName:@"xuper"];
    });
    
    return client;
}

+ (XECDSAAccount *) initor {
    
    static XECDSAAccount *initor;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        XECDSAPrivKey *accountPk = [XECDSAPrivKey fromExportedDictionary:@{
            @"Curvname":@"P-256",
            @"X":@"74695617477160058757747208220371236837474210247114418775262229497812962582435",
            @"Y":@"51348715319124770392993866417088542497927816017012182211244120852620959209571",
            @"D":@"29079635126530934056640915735344231956621504557963207107451663058887647996601"
        }];
        
        initor = [XECDSAAccount fromPrivateKey:accountPk];
    });
    
    return initor;
}

+ (XECDSAAccount *) initor2 {
    
    static XECDSAAccount *initor;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        XECDSAPrivKey *accountPk = [XECDSAPrivKey fromExportedDictionary:@{
            @"Curvname":@"P-256",
            @"X":@"108226813163516629252186832359165698878360890150296834061170161983223808516337",
            @"Y":@"96565140777404863312941966294227277967906858504679101292287026784524354450891",
            @"D":@"8936118921469427656444798839541545799022171509457793068920387673911284544541"
        }];
        
        initor = [XECDSAAccount fromPrivateKey:accountPk];
    });
    
    return initor;
}

+ (XAddress) toAddress {
    return @"eqMvtH1MQSejd4nzxDy21W1GW12cocrPF";
}

+ (XAccount) account {
    return @"XC1574829805000000@xuper";
}

+ (XHexString) blockID {
    return @"d1577f91bff29ee02ef2484db1640c331cf4c0356b5b9de7decc1ac884869629";
}

+ (XHexString) queryTxID {
    return @"d23a184063b9a272d52514af017a3a709b33291b94487e55b48f0980e7330be8";
}

@end

