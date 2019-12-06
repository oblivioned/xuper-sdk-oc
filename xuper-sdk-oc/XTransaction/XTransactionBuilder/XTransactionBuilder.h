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

/// 生成交易，在拥有全部私钥的情况下可以使用该方法，比如initor为个人地址，需要转账时，是不需要authRequire的签名的，那么可以视为拥有全部私钥，由于过程中需要使用到GRPC的接口，故此处写成了一个异步过程
/// \param opt 事务描述对象，为XTransactionOpt的派生类
/// \param initorKeypair 事务发起人的密钥对
/// \param authRequireKeypairs 所需要的authRequire(ACL)的密钥对
/// \param handleBlock 返回结果或者异常的block
+ (void) buildTrsanctionWithClient:(id<XClient> _Nonnull)client
                            option:(XTransactionOpt * _Nonnull)opt
                     initorKeypair:(id<XCryptoKeypairProtocol> _Nonnull)initorKeypair
               authRequireKeypairs:(NSArray<id<XCryptoKeypairProtocol>> *_Nullable)authRequireKeypairs
                            handle:(XTransactionBuilderResponse _Nonnull)handleBlock;

@end
