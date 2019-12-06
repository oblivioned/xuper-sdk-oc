//
//  Transaction+SDKExtension.m
//  xuper-sdk-oc-iOS
//
//  Created by apple on 2019/12/4.
//  Copyright © 2019 Martin.Ren. All rights reserved.
//

#import "Transaction+SDKExtension.h"

#import "NSString+xCodeable.h"
#import "NSData+xCodeable.h"
#import "NSMutableData+xCodeable.h"

#ifndef OmitemptySetObject
#define OmitemptySetObject(dict, lenxep, key, value) if ( value && (lenxep) ) { dict[key] = value; }
#endif

@implementation Transaction(SDKExtension)

- (NSData * _Nonnull) txMakeDigestHash {
    return self.txHashNoSignsV1;
}

- (NSData * _Nonnull) txMakeTransactionID {
    return self.txHashHasSignsV1;
}

- (NSData * _Nonnull) txHashHasSignsV1 {
    return [self txEncodeIncludeSignV1:YES].xSHA256Data.xSHA256Data;
}

- (NSData * _Nonnull) txHashNoSignsV1 {
    return [self txEncodeIncludeSignV1:NO].xSHA256Data.xSHA256Data;
}

- (NSData * _Nonnull) txEncodeIncludeSignV1:(BOOL)hasSigns {
    
    /// 写入规则说明：
    /// NSData         >>       "xBase64String"
    /// BIGNUM       >>       十进制Int写入,如 10， 2， 1000
    /// Array             >>        jsonString
    /// Bool              >>        true | false
    /// 注意只有 NSdata 格式啊话的base64字段有引号，类型没有双引号
    /// golang源码中的序列化实例 :
    /// "43MLFX5gusBD5e3W157J1JHkU4j8krK4Td64SFVaGUA="
    /// 0
    /// "ZndtWlZQVTIyZ2RiZ0pEZEVqaDV1NmdLRjVDb2h0TmJH"
    /// "AYag"
    /// 0
    /// [{"amount":"ZA==","to_addr":"V05XazNla1hlTTVNMjIzMmRZMnVDSm1FcVdoZlFpRFlU"},{"amount":"AYY8","to_addr":"ZndtWlZQVTIyZ2RiZ0pEZEVqaDV1NmdLRjVDb2h0TmJH"}]
    /// "dHJhbnNmZXIgZnJvbSBjb25zb2xl"      -- desc
    /// "157546990298498081" -- nonce
    /// 1575469902778270000 --timstemp
    /// 1 --version
    /// null
    /// "fwmZVPU22gdbgJDdEjh5u6gKF5CohtNbG"
    /// ["fwmZVPU22gdbgJDdEjh5u6gKF5CohtNbG"]
    /// false
    /// false
    //    var buf bytes.Buffer
    NSMutableString *buf = [[NSMutableString alloc] init];
        
    /// 1.txInputsArray
    for ( TxInput *txInput in self.txInputsArray ) {
        
        if ( txInput.refTxid && txInput.refTxid.length > 0 ) {
            /// lg:"43MLFX5gusBD5e3W157J1JHkU4j8krK4Td64SFVaGUA="
            [buf appendFormat:@"\"%@\"\n", txInput.refTxid.xBase64String];
        }
        
        /// lg: 1
        [buf appendFormat:@"%d\n", txInput.refOffset];
            
        if ( txInput.fromAddr && txInput.fromAddr.length > 0 ) {
            [buf appendFormat:@"\"%@\"\n", txInput.fromAddr.xBase64String];
        }
            
        if ( txInput.amount && txInput.amount.length > 0 ) {
            [buf appendFormat:@"\"%@\"\n", txInput.amount.xBase64String];
        }
            
        [buf appendFormat:@"%lld\n", txInput.frozenHeight];
    }
        
    /// 2.txOutputsArray 是数组，从结构上来看最后会格式化成json字符串
    NSError *err = NULL;
    NSString *txOutputsJsonString = [self jsonEncoderTxOutputsArray:self.txOutputsArray error:&err];
    if (err) {
        [buf appendString:@"null\n"];
    } else if ( txOutputsJsonString ) {
        [buf appendString:txOutputsJsonString];
        [buf appendString:@"\n"];
    } else {
        [buf appendString:@"null\n"];
    }
    
    /// 3.desc
    if ( self.desc && self.desc.length > 0 ) {
        [buf appendFormat:@"\"%@\"\n", self.desc.xBase64String];
    } else {
//        transfer from console
        [buf appendFormat:@"\"%@\"\n", @"transfer from console".xBase64String];
    }

    /// 4.nonce
    [buf appendFormat:@"\"%@\"\n", self.nonce];
        
    /// 5.timestamp
    [buf appendFormat:@"%lld\n", self.timestamp];
        
    /// 6.version
    [buf appendFormat:@"%d\n", self.version];
        
    /// 7.txInputsExtArray
    for ( TxInputExt *txInputExt in self.txInputsExtArray ) {
            
        [buf appendFormat:@"\"%@\"\n", txInputExt.bucket];
            
        if ( txInputExt.key && txInputExt.key.length > 0 ) {
            [buf appendFormat:@"\"%@\"\n", txInputExt.key.xBase64String];
        }
            
        if ( txInputExt.refTxid && txInputExt.refTxid.length > 0 ) {
            [buf appendFormat:@"\"%@\"\n", txInputExt.refTxid.xBase64String];
        }
            
        [buf appendFormat:@"%d\n", txInputExt.refOffset];
        
    }
    
    /// 8.txOutputsExtArray
    for ( TxOutputExt *txOutputExt in self.txOutputsExtArray ) {
    
        [buf appendFormat:@"\"%@\"\n", txOutputExt.bucket];
        
        if ( txOutputExt.key && txOutputExt.key.length > 0 ) {
            [buf appendFormat:@"\"%@\"\n", txOutputExt.key.xBase64String];
        }
        
        if ( txOutputExt.value && txOutputExt.value.length > 0 ) {
            [buf appendFormat:@"\"%@\"\n", txOutputExt.value.xBase64String];
        }
        
    }
        
    /// 9.contractRequestsArray, go源码中，如果这个对象确实需要写入一个null  ？？？？
    /// 上述规则应该适用于contractRequestsArray，initiatorSignsArray，authRequireSignsArray
    NSString *contractRequestsArrayJsonString = [self jsonEncoderContractRequestsArray:self.contractRequestsArray error:&err];
    if (err) {
        [buf appendString:@"null\n"];
    } else if ( contractRequestsArrayJsonString ) {
        [buf appendString:contractRequestsArrayJsonString];
        [buf appendString:@"\n"];
    } else {
        [buf appendString:@"null\n"];
    }
    
    /// 10.initiator
    [buf appendFormat:@"\"%@\"\n", self.initiator];
        
    /// 11.authRequireArray, 类型为NSArray<NSString*>所以直接使用NSJSONSerialization
    if ( self.authRequireArray && self.authRequireArray.count > 0 ) {
        NSData *authRequireArrayData = [NSJSONSerialization dataWithJSONObject:self.authRequireArray options:0 error:&err];
        [buf appendString:[[NSString alloc] initWithData:authRequireArrayData encoding:NSUTF8StringEncoding]];
        [buf appendString:@"\n"];
    } else {
        [buf appendString:@"null\n"];
    }

    if (hasSigns) {
        
        /// 12.initiatorSignsArray
        NSString *initiatorSignsArrayString = [self jsonEncoderSignatureArray:self.initiatorSignsArray error:&err];
        if (err) {
            [buf appendString:@"null\n"];
        } else if ( initiatorSignsArrayString ) {
            [buf appendString:initiatorSignsArrayString];
            [buf appendString:@"\n"];
        } else {
            [buf appendString:@"null\n"];
        }
        
        /// 13.authRequireSignsArray
        NSString *authRequireSignsArrayString = [self jsonEncoderSignatureArray:self.authRequireSignsArray error:&err];
        if (err) {
            [buf appendString:@"null\n"];
        } else if ( authRequireSignsArrayString ) {
            [buf appendString:authRequireSignsArrayString];
            [buf appendString:@"\n"];
        } else {
            [buf appendString:@"null\n"];
        }
        
        /// 13.authRequireSignsArray,
        /// 这里有区别的地方是，golang的pb，当对象的属性没有赋值的时候，属性为nil，在oc中的pb中，所有对象都会先进行初始化
        /// 单纯的判断xupersign 是否为nil 是不能准确判断的，需要对内容的长度做判断，但是存在的疑问依然是，
        /// 判断了xupersign写入的却依然为 authRequireSignsArray
        if (self.xuperSign &&
            self.xuperSign.publicKeysArray &&
            self.xuperSign.signature &&
            self.xuperSign.publicKeysArray_Count > 0 &&
            self.xuperSign.signature.length > 0 ) {
            
            NSString *authRequireSignsString = [self jsonEncoderSignatureArray:self.authRequireSignsArray error:&err];
            if (err) {
                [buf appendString:@"null\n"];
            } else if ( authRequireSignsString ) {
                [buf appendString:authRequireSignsString];
                [buf appendString:@"\n"];
            } else {
                [buf appendString:@"null\n"];
            }
        }
    }

    /// 14.coinbase
    [buf appendFormat:@"%@\n", self.coinbase ? @"true" : @"false"];

    /// 15.autogen
    [buf appendFormat:@"%@\n", self.autogen ? @"true" : @"false"];
        
    return [buf dataUsingEncoding:NSUTF8StringEncoding];
}

/// 手动转换TxOutput数组到json格式
- (NSString *)jsonEncoderTxOutputsArray: (NSArray<TxOutput*>*)arr error:(NSError **)error{
    
    if ( !arr || arr.count <= 0) {
        return nil;
    }
    
    NSMutableArray<NSDictionary*> *jsonArrayObject = [[NSMutableArray alloc] init];
    
    for ( TxOutput *output in arr ) {
        
        NSMutableDictionary *jobj = [NSMutableDictionary dictionary];
        
        OmitemptySetObject(jobj, output.amount.length > 0, @"amount", output.amount.xBase64String);
        OmitemptySetObject(jobj, output.toAddr.length > 0, @"to_addr", output.toAddr.xBase64String);
        if ( output.frozenHeight != 0 ) {
            jobj[@"frozen_height"] = @(output.frozenHeight);
        }
        
        if ( jobj.count > 0 ) {
            [jsonArrayObject addObject:jobj];
        }
    }
    
    if (jsonArrayObject.count <= 0) {
        return nil;
    }
    
    NSData *jdata = [NSJSONSerialization dataWithJSONObject:jsonArrayObject options:0 error:error];
    
    if (*error) {
        return nil;
    }
    
    return [[NSString alloc] initWithData:jdata encoding:NSUTF8StringEncoding];
}

- (NSString *)jsonEncoderContractRequestsArray: (NSArray<InvokeRequest*> *)arr error:(NSError **)error {
    
    if ( !arr || arr.count <= 0) {
        return nil;
    }
    
    NSMutableArray<NSDictionary*> *jsonArrayObject = [[NSMutableArray alloc] init];
    
    for ( InvokeRequest *invoke in arr ) {
        
        NSMutableDictionary *invokeJsonObject = [NSMutableDictionary dictionary];
        
        OmitemptySetObject(invokeJsonObject, invoke.moduleName.length > 0, @"module_name", invoke.moduleName);
        OmitemptySetObject(invokeJsonObject, invoke.contractName.length > 0, @"contract_name", invoke.contractName);
        OmitemptySetObject(invokeJsonObject, true, @"args", invoke.args);
        OmitemptySetObject(invokeJsonObject, invoke.amount.length > 0, @"amount", invoke.amount);

        NSMutableArray *resourceLimitsArray = [[NSMutableArray alloc] init];
        for ( ResourceLimit *limit in invoke.resourceLimitsArray ) {
            [resourceLimitsArray addObject:@{
                @"type": @(limit.type),
                @"limit": @(limit.limit)
            }];
        }
        OmitemptySetObject(invokeJsonObject, resourceLimitsArray.count > 0, @"resource_limits", resourceLimitsArray);
        
    }
    
    NSData *jdata = [NSJSONSerialization dataWithJSONObject:jsonArrayObject options:0 error:error];
    
    if (*error) {
        return nil;
    }
    
    return [[NSString alloc] initWithData:jdata encoding:NSUTF8StringEncoding];
}

- (NSString *)jsonEncoderSignatureArray: (NSArray<SignatureInfo*> *)arr error:(NSError **)error {
    
    if ( !arr || arr.count <= 0) {
        return nil;
    }
    
    NSMutableArray<NSDictionary*> *jsonArrayObject = [[NSMutableArray alloc] init];
    
    for ( SignatureInfo *info in arr ) {
        NSMutableDictionary *invokeJsonObject = [NSMutableDictionary dictionary];
        OmitemptySetObject(invokeJsonObject, info.publicKey.length > 0, @"PublicKey", info.publicKey);
        OmitemptySetObject(invokeJsonObject, info.sign.length > 0, @"Sign", info.sign.xBase64String);
        [jsonArrayObject addObject:invokeJsonObject];
    }
    
    NSData *jdata = [NSJSONSerialization dataWithJSONObject:jsonArrayObject options:0 error:error];
    
    if (*error) {
        return nil;
    }
    
    /// 由于NSMutableArray 在序列化成json的时候，对象中String出现的"/"会被写上转译字符 “\ /” 但是golang中无法正确的识别这个转译字符，需要手动删除
    NSString *beforRemoveSlash = [[NSString alloc] initWithData:jdata encoding:NSUTF8StringEncoding];
    
    return [beforRemoveSlash stringByReplacingOccurrencesOfString:@"\\/" withString:@"/"];
}

#pragma mark -- SignHash
- (XSignature _Nullable) txProcessSignWithClient:(id<XCryptoClientProtocol> _Nonnull)cryptoClient keypair:(id<XCryptoKeypairProtocol> _Nonnull)ks error:(NSError * _Nullable * _Nonnull)error {
    
    return [cryptoClient signRawMessage:self.txMakeDigestHash
                                keypair:ks
                                  error:error];
    
}

- (SignatureInfo * _Nullable) txProcessSignInfoWithClient:(id<XCryptoClientProtocol> _Nonnull)cryptoClient keypair:(id<XCryptoKeypairProtocol> _Nonnull)ks error:(NSError * _Nullable * _Nonnull)error {
    
    XSignature sig = [self txProcessSignWithClient:cryptoClient keypair:ks error:error];
    if ( *error ) {
        return nil;
    }
    
    SignatureInfo *signInfo = [SignatureInfo message];
    
    signInfo.publicKey = ks.publicKey.jsonFormatString;
    signInfo.sign = sig;
    
    return signInfo;
}
@end
