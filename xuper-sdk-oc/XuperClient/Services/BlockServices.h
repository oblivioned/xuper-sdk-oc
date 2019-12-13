//
//  BlockServices.h
//  xuper-sdk-oc-iOS
//
//  Created by apple on 2019/12/8.
//  Copyright © 2019 Martin.Ren. All rights reserved.
//

#import "AbstractServices.h"

@interface BlockServices : AbstractServices

- (void) blockWithID:(XHexString _Nonnull)blockId needContent:(BOOL)needContent handle:(XServicesResponseBlock _Nonnull)handle;

- (void) blockWithHeight:(NSUInteger)height handle:(XServicesResponseBlock _Nonnull)handle;

@end
