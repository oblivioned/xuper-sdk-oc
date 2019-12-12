//
//  NetURLServices.m
//  xuper-sdk-oc-iOS
//
//  Created by apple on 2019/12/12.
//  Copyright © 2019 Martin.Ren. All rights reserved.
//

#import "NetURLServices.h"

@implementation NetURLServices

- (void) getNetURLWithHandle:(XServicesResponseRawURL _Nonnull)handle {
    
    CommonIn *message = CommonIn.message;
    message.header = CommonIn.getRandomHeader;
    
    [self.clientRef getNetURLWithRequest:message handler:^(RawUrl * _Nullable response, NSError * _Nullable error) {
        
        if ( error ) {
            return handle(nil, error);
        }
        
        if ( response.header.error != XChainErrorEnum_Success ) {
            return handle(nil, [XError xErrorTransactionContextRPCWithCode:response.header.error]);
        }
        
        return handle(response.rawURL, nil);
        
    }];
    
}

@end
