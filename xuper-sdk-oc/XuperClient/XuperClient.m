//
//  XuperClient.m
//  xuper-sdk-oc-iOS
//
//  Created by apple on 2019/12/6.
//  Copyright © 2019 Martin.Ren. All rights reserved.
//

#import "XuperClient.h"

@interface XuperClient() {
    
    AccountServices     * accountServices;
    ACLServices         * aclServices;
    BlockServices       * blockServices;
    MultisigServices    * multisigServices;
    StatusServices      * statusServices;
    TransactionServices * txServices;
    WasmServices        * wasmServices;
    NetURLServices      * netURLServices;
    TDPOSServices       * tdposServices;
    
    NSString            * remoteHostURL;
    NSString            * bcname;
    XClient             * rpcClient;
}

@end

@implementation XuperClient

+ (instancetype _Nonnull) newClientWithHost:(NSString * _Nonnull)host blockChainName:(NSString * _Nullable)bcname {
    
    XuperClient *client = [[XuperClient alloc] init];
    
    client->remoteHostURL = host;
    
    client->bcname = bcname;
    
    client->rpcClient = [XClient clientWithGRPCHost:client->remoteHostURL];
    
    return client;
    
}

- (AccountServices *)account {
    
    if ( !self->accountServices ) {
        self->accountServices = [[AccountServices alloc] initWithClient:self.rpcClient bcname:self.blockChainName];
    }
    
    return self->accountServices;
}

- (ACLServices *)acl {
    
    if ( !self->aclServices ) {
        self->aclServices = [[ACLServices alloc] initWithClient:self.rpcClient bcname:self.blockChainName];
    }
    
    return self->aclServices;
}

- (BlockServices *)block {
    
    if (!self->blockServices) {
        self->blockServices = [[BlockServices alloc] initWithClient:self.rpcClient bcname:self.blockChainName];
    }
    
    return self->blockServices;
}

- (MultisigServices *)multisig {
    
    if (!self->multisigServices) {
        self->multisigServices = [[MultisigServices alloc] initWithClient:self.rpcClient bcname:self.blockChainName];
    }
    
    return self->multisigServices;
}

- (StatusServices *)status {
    
    if (!self->statusServices) {
        self->statusServices = [[StatusServices alloc] initWithClient:self.rpcClient bcname:self.blockChainName];
    }
    
    return self->statusServices;
}

- (TransactionServices *)tx {
    
    if (!self->txServices) {
        self->txServices = [[TransactionServices alloc] initWithClient:self.rpcClient bcname:self.blockChainName];
    }
    
    return self->txServices;
}

- (WasmServices *)wasm {
    
    if (!self->wasmServices) {
        self->wasmServices = [[WasmServices alloc] initWithClient:self.rpcClient bcname:self.blockChainName];
    }
    
    return self->wasmServices;
}

- (NetURLServices *)netURL {
    
    if ( !self->netURLServices ) {
        self->netURLServices = [[NetURLServices alloc] initWithClient:self.rpcClient bcname:self.blockChainName];
    }
    
    return self->netURLServices;
}

- (TDPOSServices *)tdpos {
    
    if ( !self->tdposServices ) {
        self->tdposServices = [[TDPOSServices alloc] initWithClient:self.rpcClient bcname:self.blockChainName];
    }
    
    return self->tdposServices;
}

- (XClient *)rpcClient {
    return self->rpcClient;
}

@end
