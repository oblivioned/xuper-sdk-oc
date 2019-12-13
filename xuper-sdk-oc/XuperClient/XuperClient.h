//
//  XuperClient.h
//  xuper-sdk-oc-iOS
//
//  Created by apple on 2019/12/6.
//  Copyright © 2019 Martin.Ren. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AccountServices.h"
#import "ACLServices.h"
#import "BlockServices.h"
#import "MultisigServices.h"
#import "StatusServices.h"
#import "TransferServices.h"
#import "TransactionServices.h"
#import "WasmServices.h"
#import "NetURLServices.h"
#import "TDPOSServices.h"

@interface XuperClient : NSObject

@property (nonnull, readonly) AccountServices * account;
@property (nonnull, readonly) ACLServices * acl;
@property (nonnull, readonly) BlockServices * block;
@property (nonnull, readonly) MultisigServices * multisig;
@property (nonnull, readonly) StatusServices * status;
@property (nonnull, readonly) TransactionServices * tx;
@property (nonnull, readonly) WasmServices * wasm;
@property (nonnull, readonly) NetURLServices * netURL;
@property (nonnull, readonly) TDPOSServices * tdpos;
@property (nonnull, readonly) TransferServices * transfer;

@property (nonnull, readonly) XClient *rpcClient;
@property (nonnull, readonly) NSString *blockChainName;

+ (instancetype _Nonnull) newClientWithHost:(NSString * _Nonnull)host blockChainName:(NSString * _Nullable)bcname;

@end
