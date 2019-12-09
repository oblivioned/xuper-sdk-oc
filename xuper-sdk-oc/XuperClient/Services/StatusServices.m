//
//  StatusServices.m
//  xuper-sdk-oc-iOS
//
//  Created by apple on 2019/12/9.
//  Copyright © 2019 Martin.Ren. All rights reserved.
//

#import "StatusServices.h"

@implementation StatusServices

- (void) statusWithHandle:(XServicesResponseStatus _Nonnull)handle {
    
    CommonIn *msg = [CommonIn message];
    msg.header = CommonIn.getRandomHeader;
    
    [self.clientRef getSystemStatusWithRequest:msg handler:^(SystemsStatusReply * _Nullable response, NSError * _Nullable error) {
    
        if ( error ) {
            return handle(nil, error);
        }
        
        if ( !error && !response ) {
            return handle(nil, self.errorRequestNoErrorResponseInvaild);
        }
        
        if ( response.header.error != XChainErrorEnum_Success ) {
            return handle(nil, [self errorResponseWithCode:response.header.error]);
        }
        
        handle(response.systemsStatus, nil);
        
    }];
    
}
@end
