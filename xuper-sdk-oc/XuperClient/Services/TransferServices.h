//
//  TransferServices.h
//  xuper-sdk-oc-iOS
//
//  Created by apple on 2019/12/9.
//  Copyright © 2019 Martin.Ren. All rights reserved.
//

#import "AbstractServices.h"
#import "XTransactionBuilder.h"
#import "XBigInt.h"

@interface TransferServices : AbstractServices

- (void) transferWithFrom:(XAddress _Nonnull)from
                       to:(XAddress _Nonnull)toAddr
                   amount:(XBigInt * _Nonnull)amount
                  remarks:(NSString * _Nullable)remarks
             forzenHeight:(NSInteger)forzenHeight
            initorKeypair:(id<XCryptoKeypairProtocol> _Nonnull)initorKeypair
      authRequireKeypairs:(NSArray<id<XCryptoKeypairProtocol>> *_Nullable)authRequireKeypairs
                   handle:(XServicesResponseHash _Nonnull)handle;

@end

