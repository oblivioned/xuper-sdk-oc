//
//  AbstractServices.m
//  xuper-sdk-oc-iOS
//
//  Created by apple on 2019/12/6.
//  Copyright © 2019 Martin.Ren. All rights reserved.
//

#import "AbstractServices.h"
#import "XTransactionBuilder.h"

#define XHandleAbsServicesError(handle, rsp, err)\
if ( (err) ) {\
    return handle(nil, (err));\
}\
if ( (rsp).header.error != XChainErrorEnum_Success ) {\
    return handle(nil, [XError xErrorTransactionContextRPCWithCode:rsp.header.error]);\
}

@implementation AbstractServices

- (instancetype _Nonnull) initWithClient:(id<XClient> _Nonnull)clientRef bcname:(NSString * _Nullable)blockChainName {
    
    self = [super init];
    
    self.clientRef = clientRef;
    
    if (blockChainName) {
        self.blockChainName = blockChainName;
    } else {
        self.blockChainName = @"xuper";
    }
    
    return self;
}

- (void) preExecTransaction:(Transaction * _Nonnull)tx handle:(XServicesResponseInvoke _Nonnull)handle {
    return [self preExecInvokesWithInitor:tx.initiator invokes:tx.contractRequestsArray authrequires:tx.authRequireArray handle:handle];
}

- (void) preExecInvokesWithInitor:(NSString * _Nonnull)initor invokes:(NSArray<InvokeRequest*> * _Nonnull)invokes authrequires:(NSArray<NSString*>*)authrequires handle:(XServicesResponseInvoke _Nonnull)handle {
    
    InvokeRPCRequest *message = InvokeRPCRequest.message;
    message.header = InvokeRequest.getRandomHeader;
    message.bcname = self.blockChainName;
    message.initiator = initor;
    
    [message.requestsArray addObjectsFromArray:invokes];
    if ( authrequires ) {
        [message.authRequireArray addObjectsFromArray:authrequires];
    } else {
        [message.authRequireArray addObject:initor];
    }
    
    [self.clientRef preExecWithRequest:message handler:^(InvokeRPCResponse * _Nullable response, NSError * _Nullable error) {
        
        XHandleAbsServicesError(handle, response, error);
        
        handle(response.response, nil);
        
    }];
}

- (void) preExecOpt:(XTransactionOpt * _Nonnull)opt handle:(XServicesResponseInvoke _Nonnull)handle {
    
    [XTransactionBuilder buildPreExecTransactionWithClient:self.clientRef option:opt handle:^(Transaction * _Nullable tx, NSError * _Nullable error) {
       
        if ( error ) {
            return handle(nil, error);
        }
        
        return [self preExecTransaction:tx handle:handle];
    }];
}

@end
