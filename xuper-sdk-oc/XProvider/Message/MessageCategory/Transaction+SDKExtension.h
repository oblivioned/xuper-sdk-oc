//
//  Transaction+SDKExtension.h
//  xuper-sdk-oc-iOS
//
//  Created by apple on 2019/12/4.
//  Copyright © 2019 Martin.Ren. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Xchain.pbobjc.h"
#import "XCommon.h"
#import "XCryptoClientProtocol.h"

@interface Transaction(SDKExtension)

/// 从golang的源码中得知，交易的Hash过程如下,因为很可能在后续的维护中升级这个算法，所以此处加入V1标示，对应 <= 3.4 xuper的交易版本
/// 1.将Transaction序列化，（json）
/// 2.json计算SHA256
/// 源码位置 txhash.go:33 func encodeTxData(tx *pb.Transaction, includeSigns bool) ([]byte, error);
/// golang源码中的序列化实例 :
/// "43MLFX5gusBD5e3W157J1JHkU4j8krK4Td64SFVaGUA="
/// 0
/// "ZndtWlZQVTIyZ2RiZ0pEZEVqaDV1NmdLRjVDb2h0TmJH"
/// "AYag"
/// 0
/// [{"amount":"ZA==","to_addr":"V05XazNla1hlTTVNMjIzMmRZMnVDSm1FcVdoZlFpRFlU"},{"amount":"AYY8","to_addr":"ZndtWlZQVTIyZ2RiZ0pEZEVqaDV1NmdLRjVDb2h0TmJH"}]
/// "dHJhbnNmZXIgZnJvbSBjb25zb2xl"
/// "157546990298498081"
/// 1575469902778270000
/// 1
/// null
/// "fwmZVPU22gdbgJDdEjh5u6gKF5CohtNbG"
/// ["fwmZVPU22gdbgJDdEjh5u6gKF5CohtNbG"]
/// false
/// false
/// 疑问1: 这里序列化的格式生成的txid 是否会在节点收到以后重新计算和校验？因为没有找到类似txhash这个字段。如果不校验，如何确保交易没有发生篡改？
/// 使用golang版本中相同的算法序列化transaction，注意正向序列化得到的结果的NSData是无法逆向计算得到Trnasaction对象的，因为encoder的过程只是把值拼接，而且算法中会跳过一些null值，所以无法逆向序列化！
- (NSData * _Nonnull) txEncodeIncludeSignV1:(BOOL)hasSigns;

- (NSData * _Nonnull) txHashNoSignsV1;
- (NSData * _Nonnull) txHashHasSignsV1;

/// 创建交易摘要的Hash值 - 不包含签名相关字段
- (NSData * _Nonnull) txMakeDigestHash;

/// 创建该交易的TXID
- (NSData * _Nonnull) txMakeTransactionID;

/// 对交易的双重SHA签名
- (XSignature _Nullable) txProcessSignWithClient:(id<XCryptoClientProtocol> _Nonnull)cryptoClient keypair:(id<XCryptoKeypairProtocol> _Nonnull)ks error:(NSError * _Nullable * _Nonnull)error;

- (SignatureInfo * _Nullable) txProcessSignInfoWithClient:(id<XCryptoClientProtocol> _Nonnull)cryptoClient keypair:(id<XCryptoKeypairProtocol> _Nonnull)ks error:(NSError * _Nullable * _Nonnull)error;

/// 检测签名是否正确，一般来说如果返回true，则说明这个交易可以接入Tx_Status中直接进行grpc调用postTx
- (BOOL) verifyWithCryptoType:(XCryptoTypeStringKey _Nullable)cryptoType error:(NSError * _Nonnull * _Nullable)error;

- (void) payloadTxSigns:(SignatureInfo * _Nonnull)initorSigs authRequireSigns:(NSArray<SignatureInfo*> *_Nonnull)authRequiresSigns;

@end
