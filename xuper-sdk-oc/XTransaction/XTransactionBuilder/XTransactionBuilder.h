//
//  XTransactionBuilder.h
//  xuper-sdk-oc-iOS
//
//  Created by apple on 2019/12/6.
//  Copyright © 2019 Martin.Ren. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Xchain.pbobjc.h"
#import "XTransactionBuilder.h"
#import "XTransactionDesc.h"
#import "XTransactionOpt.h"
#import "XCryptoKeypairProtocol.h"
#import "XClient.h"

typedef void(^XTransactionBuilderResponse)(Transaction * _Nullable tx, NSError * _Nullable error);

@interface XTransactionBuilder : NSObject

/*!
 * 创建一个包含签名的交易
 *
 * @discussion
 * 生成交易，包含签名过程，在拥有全部私钥的情况下可以使用该方法，比如initor为个人地址，需要转账时，是不需要authRequire的签名的，
 * 那么可以视为拥有全部私钥，由于过程中需要使用到GRPC的接口，故此处写成了一个异步过程,不推荐直接调用除非你清楚它的目的，推荐
 * 使用build系列方法和 buildPreExecx系列方法.
 *
 * @param client
 * XClient实现类,用于GRPC通讯
 *
 * @param opt
 * 事务描述对象，为XTransactionOpt的派生类
 *
 * @param ignoreFeeCheck
 * 是否忽略手续费检测
 *
 * @param initorKeypair
 * 事务发起人的密钥对
 *
 * @param authRequireKeypairs
 * 所需要的authRequire(ACL)的密钥对
 *
 * @param handleBlock 返回结果或者异常的block
 */
+ (void) trsanctionWithClient:(id<XClient> _Nonnull)client
                       option:(XTransactionOpt * _Nonnull)opt
               ignoreFeeCheck:(BOOL)ignoreFeeCheck
                initorKeypair:(id<XCryptoKeypairProtocol> _Nullable)initorKeypair
          authRequireKeypairs:(NSArray<id<XCryptoKeypairProtocol>> *_Nullable)authRequireKeypairs
                       handle:(XTransactionBuilderResponse _Nonnull)handleBlock;

/*!
 * 生成不包含签名的交易,可用于预执行过程
 *
 * @param client
 * XClient实现类,用于GRPC通讯
 *
 * @param opt
 * 事务描述对象，为XTransactionOpt的派生类
 *
 * @param handleBlock
 * 返回结果或者异常的block
 *
 */
+ (void) buildPreExecTransactionWithClient:(id<XClient> _Nonnull)client
                                    option:(XTransactionOpt * _Nonnull)opt
                                    handle:(XTransactionBuilderResponse _Nonnull)handleBlock;

/*!
 * 已知所有密钥对时，为Transaction对象填充的签名，若签名已经存在则覆盖原签名， 签名会填充在传入的Transaction对象中，若出现异常，tx对象中关于签名的修改会全部回滚
 *
 * @param tx
 * 需要填充签名的交易
 *
 * @param initorKeypair
 * 事务发起人的密钥对
 *
 * @param authRequireKeypairs
 * 所需要的authRequire(ACL)的密钥对
 *
 * @param error
 * 错误输出指针
 *
 * @return YES:成功填充签名，NO:填充签名失败
 */
+ (BOOL) payloadSignTransaction:(Transaction * _Nonnull)tx
                     cryptoType:(XCryptoTypeStringKey _Nonnull)cryptoType
                  initorKeypair:(id<XCryptoKeypairProtocol> _Nonnull)initorKeypair
            authRequireKeypairs:(NSArray<id<XCryptoKeypairProtocol>> *_Nonnull)authRequireKeypairs
                          error:(NSError * _Nonnull * _Nullable)error;


/*!
 * 已知签名串直接填充Transaction中的签名信息
 *
 * @param tx
 * 需要填充签名的交易
 *
 * @param initorSigns
 * 事务发起人的签名内容
 *
 * @param authRequireSigns
 * 所需要的authRequire(ACL)的签名内容
 *
 */
+ (void) payloadSignTransaction:(Transaction * _Nonnull)tx
                    initorSigns:(SignatureInfo * _Nonnull)initorSigns
               authRequireSigns:(NSArray<SignatureInfo *> *_Nonnull)authRequireSigns;

@end
