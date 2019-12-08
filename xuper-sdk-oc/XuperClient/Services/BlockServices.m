//
//  BlockServices.m
//  xuper-sdk-oc-iOS
//
//  Created by apple on 2019/12/8.
//  Copyright © 2019 Martin.Ren. All rights reserved.
//

#import "BlockServices.h"

#define XHandleBlockServicesError(handle, rsp, err)\
if ( (err) ) {\
    return handle(nil, (err));\
}\
if ( !(err) && !(rsp) ) {\
    return handle(nil, self.errorRequestNoErrorResponseInvaild);\
}\
if ( (rsp).header.error != XChainErrorEnum_Success ) {\
    return handle(nil, [self errorResponseWithCode:response.header.error]);\
}

@implementation BlockServices

- (void) blockWithID:(XHexString _Nonnull)blockId needContent:(BOOL)needContent handle:(XServicesResponseBlock _Nonnull)handle {
    
    XBigInt *blockIDInt = [[XBigInt alloc] initWithHexString:blockId];
    
    BlockID *message = BlockID.message;
    message.header = BlockID.getRandomHeader;
    message.bcname = self.blockChainName;
    message.blockid = blockIDInt.data;
    message.needContent = needContent;
    
    [self.clientRef getBlockWithRequest:message handler:^(Block * _Nullable response, NSError * _Nullable error) {
       
        XHandleBlockServicesError(handle, response, error);
        
        handle(response.block, nil);
        
    }];
}

- (void) blockWithHeight:(NSUInteger)height handle:(XServicesResponseBlock _Nonnull)handle {
    
    BlockHeight *message = BlockHeight.message;
    message.header = BlockHeight.getRandomHeader;
    message.bcname = self.blockChainName;
    message.height = height;
    
    [self.clientRef getBlockByHeightWithRequest:message handler:^(Block * _Nullable response, NSError * _Nullable error) {
       
        XHandleBlockServicesError(handle, response, error);
        
        handle(response.block, nil);
        
    }];
}

@end
