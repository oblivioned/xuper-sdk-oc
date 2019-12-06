//
//  XTransactionOpt+Transfer.h
//  xuper-sdk-oc-iOS
//
//  Created by apple on 2019/12/6.
//  Copyright © 2019 Martin.Ren. All rights reserved.
//

#import "XTransactionOpt.h"
#import "XBigInt.h"
#import "XCryptoAccountProtocol.h"


@interface XTransactionOpt(Transfer)

+ (instancetype _Nonnull) transferOptWithFrom:(XAddress _Nonnull)from
                                           to:(XAddress _Nonnull)toAddr
                                       amount:(XBigInt * _Nonnull)amount
                                      remarks:(NSString * _Nullable)remarks
                                 forzenHeight:(int64_t)forzenHeight;

@end
