//
//  WasmServices.h
//  xuper-sdk-oc-iOS
//
//  Created by apple on 2019/12/10.
//  Copyright © 2019 Martin.Ren. All rights reserved.
//

#import "AbstractServices.h"

@interface WasmServices : AbstractServices

- (void) invokeWithAddress:(XAddress _Nonnull)address
              authRequires:(NSArray<XAddress> * _Nonnull)authRequires
              contractName:(NSString * _Nonnull)contractName
                methodName:(NSString * _Nonnull)methodName
                      args:(NSDictionary<NSString*, NSString*> * _Nullable)args
              forzenHeight:(NSUInteger)forzenHeight
             initorKeypair:(id<XCryptoKeypairProtocol> _Nonnull)initorKeypair
       authRequireKeypairs:(NSArray<id<XCryptoKeypairProtocol>> *_Nonnull)authRequireKeypairs
                  feeAsker:(XServicesResponseFeeAsker _Nullable) feeAsker
                    handle:(XServicesResponseHash _Nonnull)handle;

- (void) queryWithAddress:(XAddress _Nonnull)address
             authRequires:(NSArray<XAddress> * _Nonnull)authRequires
             contractName:(NSString * _Nonnull)contractName
               methodName:(NSString * _Nonnull)methodName
                     args:(NSDictionary<NSString*, NSString*> * _Nullable)args
                   handle:(XServicesResponseInvoke _Nonnull)handle;

@end
