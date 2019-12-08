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

@end
