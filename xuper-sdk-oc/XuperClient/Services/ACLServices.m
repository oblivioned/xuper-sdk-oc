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
if ( (rsp).header.error != XChainErrorEnum_Success ) {\
    return handle(nil, [XError xErrorTransactionContextRPCWithCode:rsp.header.error]);\
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

- (void) setContractMethodACLWithAddress:(XAddress _Nonnull)address
                            authRequires:(NSArray<XAddress> * _Nonnull)authRequires
                            contractName:(NSString * _Nonnull)contractName
                              methodName:(NSString * _Nonnull)methodName
                                     acl:(XTransactionACL * _Nonnull)acl
                           initorKeypair:(id<XCryptoKeypairProtocol> _Nullable)initorKeypair
                     authRequireKeypairs:(NSArray<id<XCryptoKeypairProtocol>> *_Nullable)authRequireKeypairs
                                feeAsker:(XServicesResponseFeeAsker _Nullable)feeAsker
                                  handle:(XServicesResponseHash _Nonnull)handle {
    
    XTransactionDescInvoke *invokeDesc = [[XTransactionDescInvoke alloc] init];
    
    invokeDesc.moduleName = XContractNameStandardModuleNameKernel;
    invokeDesc.methodName = @"SetMethodAcl";
    invokeDesc.args = @{
        @"contract_name": contractName,
        @"method_name": methodName,
        @"acl": acl.aclAuthRequireString
    };
    
    XTransactionOpt *opt = [[XTransactionOpt alloc] init];
    opt.from = address;
    opt.frozenHeight = 0;
    opt.desc = invokeDesc;
        
    [self preExecOpt:opt handle:^(InvokeResponse * _Nullable response, NSError * _Nullable error) {
        
        if ( error ) {
            return handle(nil, error);
        }
       
        /// 设置opt的手续费后继续交易
        BOOL alwaysSend = true;
        opt.fee = [[XBigInt alloc] initWithUInt:response.gasUsed];
        if ( feeAsker ) {
            alwaysSend = feeAsker( opt.fee );
        }
        
        if (!alwaysSend) {
            return handle(nil, XError.xErrorAksFeeReject);
        }
        
        [XTransactionBuilder trsanctionWithClient:self.clientRef
                                           option:opt
                                   ignoreFeeCheck:NO
                                    initorKeypair:initorKeypair
                              authRequireKeypairs:authRequireKeypairs
                                           handle:^(Transaction * _Nullable tx, NSError * _Nullable error) {
            
            TxStatus *tx_status = TxStatus.message;
            tx_status.header = TxStatus.getRandomHeader;
            tx_status.bcname = self.blockChainName;
            tx_status.status = TransactionStatus_Unconfirm;
            tx_status.tx = tx;
            tx_status.txid = tx.txid;
            
            [self.clientRef postTxWithRequest:tx_status handler:^(CommonReply * _Nullable response, NSError * _Nullable error) {
                
                XHandleACLServicesError(handle, response, error);
                
                handle(tx.txid.xHexString, nil);
                
            }];
            
        }];
    }];
}

@end
