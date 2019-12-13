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
#import "Transaction+SDKExtension.h"

@interface Transaction(SDKExtension)

/*!
 * 将Transaction对象按照xuper的规则就行序列化，一般用于求取签名原串或者计算TXID。
 *
 * @param hasSigns
 * 是否包含签名,Transaction对象中有两个属性描述签名，在生产TXID时是需要写入签名信息的，但是在计算签名原串时则不需要。
 *
 * @result
 * 结果
 */
- (NSData * _Nonnull) txEncodeIncludeSignV1:(BOOL)hasSigns;

/*!
 * 将Transaction对象按照xuper的规则就行序列化，不包含签名对应xuper V1 版本的Transaction规则
 *
 * @result
 * 结果
 */
- (NSData * _Nonnull) txHashNoSignsV1;

/*!
 * 将Transaction对象按照xuper的规则就行序列化，包含签名一般用于签名后计算TXID
 *
 * @result
 * 结果
 */
- (NSData * _Nonnull) txHashHasSignsV1;

/*!
 * 获取该交易的摘要Hash值
 *
 * @result
 * 摘要Hash的NSData对象
 */
- (NSData * _Nonnull) txMakeDigestHash;

/*!
 * 获取该交易的TXID
 *
 * @result
 * TXID
 */
- (NSData * _Nonnull) txMakeTransactionID;

/*!
 * 使用对应的密钥对，对交易签名，并且返回签名内容XSignature，方法不会把签名结果写入当前交易。
 *
 * @param cryptoClient
 * 实现了XCryptoClientProtocol协议的加解密算法支持对象
 *
 * @param ks
 * 签名使用的密钥对
 *
 * @param error
 * 错误输出对象指针
 *
 * @result
 * 签名串
 */
- (XSignature _Nullable) txProcessSignWithClient:(id<XCryptoClientProtocol> _Nonnull)cryptoClient keypair:(id<XCryptoKeypairProtocol> _Nonnull)ks error:(NSError * _Nonnull * _Nullable)error;

/*!
 * 使用对应的密钥对，对交易签名，并且返回SignatureInfo对象，该对象可以用于下文调用其他
 *
 * @param cryptoClient
 * 实现了XCryptoClientProtocol协议的加解密算法支持对象
 *
 * @param ks
 * 签名使用的密钥对
 *
 * @param error
 * 错误对象输出指针
 *
 * @result
 * 包含X，Y，Sign三个对象，其中X,Y是公钥参数，Sign为签名的实际结果
 */
- (SignatureInfo * _Nullable) txProcessSignInfoWithClient:(id<XCryptoClientProtocol> _Nonnull)cryptoClient keypair:(id<XCryptoKeypairProtocol> _Nonnull)ks error:(NSError * _Nonnull * _Nullable )error;

/*!
 * 检测签名是否正确，或者说用来检测交易是否具备发送条件，一般来说如果返回true，则说明这个交易可以接入Tx_Status中直接进行grpc调用postTx。
 *
 * @param cryptoType
 * 已经实现的加解密类型
 *
 * @param error
 * 错误对象输出指针
 *
 * @result
 * 验证结果
*/
- (BOOL) verifyWithCryptoType:(XCryptoTypeStringKey _Nullable)cryptoType error:(NSError * _Nonnull * _Nullable)error;

/*!
 * 将签名串填充入Transaction对象中
 *
 * @discussion
 * Transaction的签名有两个类型一个是initor，可认为是交易发起地址，另一个为authRequires，可认为是授权人，根据ACL的设置提供签名，
 * 若ACL要求需要authRequires，而实际交易中没有附带足够权值的authRequires节点回返回签名验证失败。填充方法中并不会对交易就行
 * ACL的获取和验证操作。
 *
 * @param initorSigs
 * 交易发起者的签名，也可以理解为from的签名
 *
 * @param authRequiresSigns
 * 授权签名，请按照对应交易的ACL就行填充，若没有ACL则填写initor的签名串
 *
 */
- (void) payloadTxSigns:(SignatureInfo * _Nonnull)initorSigs authRequireSigns:(NSArray<SignatureInfo*> *_Nonnull)authRequiresSigns;

@end
