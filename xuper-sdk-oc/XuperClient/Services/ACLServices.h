//
//  ACLServices.h
//  xuper-sdk-oc-iOS
//
//  Created by apple on 2019/12/8.
//  Copyright © 2019 Martin.Ren. All rights reserved.
//

#import "AbstractServices.h"

@interface ACLServices : AbstractServices

- (void) queryWithAccount:(XAccount _Nonnull)account handle:(XServicesResponseTransactionACL _Nonnull)handle;

- (void) setContractMethodACLWithAddress:(XAddress _Nonnull)address
                            authRequires:(NSArray<XAddress> * _Nonnull)authRequires
                            contractName:(NSString * _Nonnull)contractName
                              methodName:(NSString * _Nonnull)methodName
                                     acl:(XTransactionACL * _Nonnull)acl
                           initorKeypair:(id<XCryptoKeypairProtocol> _Nullable)initorKeypair
                     authRequireKeypairs:(NSArray<id<XCryptoKeypairProtocol>> *_Nullable)authRequireKeypairs
                                feeAsker:(XServicesResponseFeeAsker _Nullable)feeAsker
                                  handle:(XServicesResponseHash _Nonnull)handle;


@end
