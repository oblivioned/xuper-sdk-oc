//
//  TransactionServices.h
//  xuper-sdk-oc-iOS
//
//  Created by apple on 2019/12/10.
//  Copyright © 2019 Martin.Ren. All rights reserved.
//

#import "AbstractServices.h"

@interface TransactionServices : AbstractServices

- (void) queryWithTXID:(XHexString _Nonnull)txid handle:(XServicesResponseTransaction _Nonnull)handle;

@end
