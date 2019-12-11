//
//  AccountServices.h
//  xuper-sdk-oc-iOS
//
//  Created by apple on 2019/12/6.
//  Copyright © 2019 Martin.Ren. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "AbstractServices.h"
#import "XTransactionDescInvoke.h"

@interface AccountServices : AbstractServices

- (void) balanceWithAddress:(XAddress _Nonnull)addr handle:(XServicesResponseBigInt _Nonnull)handle;

- (void) balanceFrozenWithAddress:(XAddress _Nonnull)addr handle:(XServicesResponseBigInt _Nonnull)handle;

- (void) contractsWithAccount:(XAccount _Nonnull)acc handle:(XServicesResponseContracts _Nonnull)handle;

- (void) queryAccountListWithAddress:(XAddress _Nonnull)addr handle:(XServicesResponseAccounts _Nonnull)handle;

- (void) newAccountWithAddress:(XAddress _Nonnull)address
                           acl:(XTransactionACL * _Nonnull)acl
                 initorKeypair:(id<XCryptoKeypairProtocol> _Nonnull)keypiar
                      feeAsker:(XServicesResponseFeeAsker _Nullable)feeAsker
                        handle:(XServicesResponseCommonReply _Nonnull)handle;

- (void) newAccountWithAddress:(XAddress _Nonnull)address
                   accountName:(unsigned char[_Nullable 18])accountName
                           acl:(XTransactionACL * _Nonnull)acl
                 initorKeypair:(id<XCryptoKeypairProtocol> _Nonnull)keypiar
                      feeAsker:(XServicesResponseFeeAsker _Nullable)feeAsker
                        handle:(XServicesResponseCommonReply _Nonnull)handle;

/// 在xchain-cli中是需要通过GRPC通讯后在本地存储私钥，这里提供一个同名的API方便使用，但是不推荐在这里使用，请使用XCrypto中的系列方法来创建和保存私钥,若不指定type，则使用default（ECDSA）ps:其实也暂不支持别的类型   \0.0/
- (id<XCryptoKeypairProtocol> _Nonnull) newKeysWithCryptoType:(XCryptoTypeStringKey _Nullable)type;

@end
