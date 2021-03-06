//
//  MultisigServices.m
//  xuper-sdk-oc-iOS
//
//  Created by apple on 2019/12/8.
//  Copyright © 2019 Martin.Ren. All rights reserved.
//

#import "MultisigServices.h"
#import "Xcheck.pbrpc.h"
#import "XCryptoFactory.h"

#define XHandleMultiSigServicesError(handle, rsp, err)\
if ( (err) ) {\
    return handle(nil, (err));\
}\
if ( (rsp).header.error != XChainErrorEnum_Success ) {\
    return handle(nil, [XError xErrorTransactionContextRPCWithCode:rsp.header.error]);\
}

@implementation MultisigServices

- (void) genTransactionWithOption:(XTransactionOpt * _Nonnull)opt
                    initorKeypair:(id<XCryptoKeypairProtocol> _Nullable)initorKeypair
              authRequireKeypairs:(NSArray<id<XCryptoKeypairProtocol>> * _Nullable)authRequireKeypairs
                           handle:(XTransactionBuilderResponse _Nonnull)handleBlock {
    
    if ( [opt.desc isKindOfClass:[XTransactionDescInvoke class]] && !opt.fee ) {
        
        [self preExecOpt:opt handle:^(InvokeResponse * _Nullable response, NSError * _Nullable error) {
            
            if ( error ) {
                return handleBlock(nil, error);
            }
            
            opt.fee = [[XBigInt alloc] initWithUInt:response.gasUsed];
            
            return [XTransactionBuilder trsanctionWithClient:self.clientRef
                                                      option:opt
                                              ignoreFeeCheck:NO
                                               initorKeypair:initorKeypair
                                         authRequireKeypairs:authRequireKeypairs
                                                      handle:handleBlock];
            
        }];
        
    } else {
    
        return [XTransactionBuilder trsanctionWithClient:self.clientRef
                                                  option:opt
                                          ignoreFeeCheck:NO
                                           initorKeypair:initorKeypair
                                     authRequireKeypairs:authRequireKeypairs
                                                  handle:handleBlock];
    }
}

- (void) getSignWithTransaction:(Transaction * _Nonnull)tx fromRemoteNodeURL:(NSString * _Nonnull)remoteNodeURL secureConnections:(BOOL)secureConnections handle:(XServicesResponseSignatureInfo _Nonnull)handle {

    Xcheck *checkClient = [[Xcheck alloc] initWithHost:remoteNodeURL];
    
    if (!secureConnections) {
        [GRPCCall useInsecureConnectionsForHost:remoteNodeURL];
    }
    
    TxStatus *tx_status = TxStatus.message;
    tx_status.header = TxStatus.getRandomHeader;
    tx_status.bcname = self.blockChainName;
    tx_status.status = TransactionStatus_Unconfirm;
    tx_status.tx = tx;
    tx_status.txid = tx.txid;
    
    [checkClient complianceCheckWithRequest:tx_status handler:^(ComplianceCheckResponse * _Nullable response, NSError * _Nullable error) {
        
        XHandleMultiSigServicesError(handle, response, error);
        
        handle(response.signature, nil);
        
    }];
    
}

- (SignatureInfo * _Nullable) signTransaction:(Transaction * _Nonnull)tx
                                   cryptoType:(XCryptoTypeStringKey _Nonnull)cryptoType
                                      keypair:(id<XCryptoKeypairProtocol> _Nonnull)ak
                                        error:(NSError * _Nonnull * _Nullable)error {

    id<XCryptoClientProtocol> cryptoClient = [XCryptoFactory cryptoClientWithCryptoType:cryptoType];
    
    SignatureInfo *sig = [tx txProcessSignInfoWithClient:cryptoClient keypair:ak error:error];
    if (*error) {
        return nil;
    }

    return sig;
}

- (void) sendSignedTransaction:(Transaction * _Nonnull)signedTx
                    cryptoType:(XCryptoTypeStringKey _Nonnull)cryptoType
                        handle:(XServicesResponseHandle _Nonnull)handle {
    
    /// 验证签名
    NSError *verifyError;
    if ( ![signedTx verifyWithCryptoType:cryptoType error:&verifyError] ) {
        handle(false, verifyError);
        return;
    }
    if ( verifyError ) {
        handle(false, verifyError);
        return ;
    }
    
    TxStatus *tx_status = TxStatus.message;
    tx_status.header = TxStatus.getRandomHeader;
    tx_status.bcname = self.blockChainName;
    tx_status.status = TransactionStatus_Unconfirm;
    tx_status.tx = signedTx;
    tx_status.txid = signedTx.txid;
    
    [self.clientRef postTxWithRequest:tx_status handler:^(CommonReply * _Nullable response, NSError * _Nullable error) {
        
        if ( error ) {
            return handle(false, error);
        }

        if ( response.header.error != XChainErrorEnum_Success ) {
            return handle(false, [XError xErrorTransactionContextRPCWithCode:response.header.error]);
        }
        
        handle(true, nil);
    }];
    
}

@end
