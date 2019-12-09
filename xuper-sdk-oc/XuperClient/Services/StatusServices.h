//
//  StatusServices.h
//  xuper-sdk-oc-iOS
//
//  Created by apple on 2019/12/9.
//  Copyright © 2019 Martin.Ren. All rights reserved.
//

#import "AbstractServices.h"
#import "XTransactionBuilder.h"

@interface StatusServices : AbstractServices

- (void) statusWithHandle:(XServicesResponseStatus _Nonnull)handle;

@end
