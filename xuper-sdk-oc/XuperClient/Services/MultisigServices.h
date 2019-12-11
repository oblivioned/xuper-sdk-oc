//
//  MultisigServices.h
//  xuper-sdk-oc-iOS
//
//  Created by apple on 2019/12/8.
//  Copyright © 2019 Martin.Ren. All rights reserved.
//

#import "AbstractServices.h"
#import "XTransactionBuilder.h"

@interface MultisigServices : AbstractServices

/// 实际是调用 XTransactionBuilder buildTrsanctionWithClient:option:initorKeypair:authRequireKeypairs:handle
- (void) genTransactionWithOption:(XTransactionOpt * _Nonnull)opt
                    initorKeypair:(id<XCryptoKeypairProtocol> _Nullable)initorKeypair
              authRequireKeypairs:(NSArray<id<XCryptoKeypairProtocol>> *_Nullable)authRequireKeypairs
                           handle:(XTransactionBuilderResponse _Nonnull)handleBlock;

/// 想远程节点请求一个交易(Transaction)的签名
/// \param tx 需要请求签名的原始交易（即不包含签名的交易）
/// \param remoteNodeURL 远程节点地址如 "111.222.12.1:8888"
/// \param secureConnections 是否使用安全连接，基于3.4版本，对于的xuper节点还未支持安全的grpc连接，所以请暂时使用 "NO"
/// \param handle 回调block
- (void) getSignWithTransaction:(Transaction * _Nonnull)tx
              fromRemoteNodeURL:(NSString * _Nonnull)remoteNodeURL
              secureConnections:(BOOL)secureConnections
                         handle:(XServicesResponseSignatureInfo _Nonnull)handle;

- (SignatureInfo * _Nullable) signTransaction:(Transaction * _Nonnull)tx
                                   cryptoType:(XCryptoTypeStringKey _Nonnull)cryptoType
                                      keypair:(id<XCryptoKeypairProtocol> _Nonnull)ak
                                        error:(NSError * _Nonnull * _Nullable)error;

/// 验证并且发送一个已经完成签名的交易，可以使用 Transaction verifyWithCryptoType:error 进行预先验证，成功后在吊起发送，实现中也包含验证的方法，关于Txid的说明，如果交易正确的完成了填充，可以直接通过tx.txID获取，此处不在返回txid，确认发送成功后，可以根据txid，等待节点处理后进行tx query
/// \param signedTx 已经填充完毕的交易
/// \param cryptoType 加解密算法类型
/// \param handle 回调block
- (void) sendSignedTransaction:(Transaction * _Nonnull)signedTx
                    cryptoType:(XCryptoTypeStringKey _Nonnull)cryptoType
                        handle:(XServicesResponseHandle _Nonnull)handle;
@end
