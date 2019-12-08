//
//  ACLServices.m
//  xuper-sdk-oc-iOS
//
//  Created by apple on 2019/12/8.
//  Copyright © 2019 Martin.Ren. All rights reserved.
//

#import "ACLServices.h"

#define XHandleACLServicesError(handle, rsp, err)\
if ( (err) ) {\
    return handle(nil, (err));\
}\
if ( !(err) && !(rsp) ) {\
    return handle(nil, self.errorRequestNoErrorResponseInvaild);\
}\
if ( (rsp).header.error != XChainErrorEnum_Success ) {\
    return handle(nil, [self errorResponseWithCode:response.header.error]);\
}

@implementation ACLServices

- (void) queryWithAccount:(XAccount _Nonnull)account handle:(XServicesResponseTransactionACL _Nonnull)handle {
    
    AclStatus *message = AclStatus.message;
    
    message.header = AclStatus.getRandomHeader;
    message.bcname = self.blockChainName;
    message.confirmed = false;
    message.accountName = account;
    
    [self.clientRef queryACLWithRequest:message handler:^(AclStatus * _Nullable response, NSError * _Nullable error) {
        
        XHandleACLServicesError(handle, response, error);
        
        handle( [[XTransactionACL alloc] initWithPBACL:response.acl], nil);
        
    }];
    
}

@end
