//
//  WasmServices.m
//  xuper-sdk-oc-iOS
//
//  Created by apple on 2019/12/10.
//  Copyright © 2019 Martin.Ren. All rights reserved.
//

#import "WasmServices.h"
#import "XTransactionDescInvoke.h"
#import "XTransactionOpt+Contracts.h"

#define XHandleWasmServicesError(handle, rsp, err)\
if ( (err) ) {\
    return handle(nil, (err));\
}\
if ( !(err) && !(rsp) ) {\
    return handle(nil, self.errorRequestNoErrorResponseInvaild);\
}\
if ( (rsp).header.error != XChainErrorEnum_Success ) {\
    return handle(nil, [self errorResponseWithCode:response.header.error]);\
}

@implementation WasmServices

- (void) invokeWithAddress:(XAddress _Nonnull)address
              authRequires:(NSArray<XAddress> *_Nonnull)authRequires
              contractName:(NSString * _Nonnull)contractName
                methodName:(NSString * _Nonnull)methodName
                      args:(NSDictionary<NSString*, NSString*> * _Nullable)args
              forzenHeight:(NSUInteger)forzenHeight
             initorKeypair:(id<XCryptoKeypairProtocol> _Nonnull)initorKeypair
       authRequireKeypairs:(NSArray<id<XCryptoKeypairProtocol>> * _Nonnull)authRequireKeypairs
                  feeAsker:(XServicesResponseFeeAsker _Nullable) feeAsker
                    handle:(XServicesResponseHash _Nonnull)handle {
    
    XTransactionDescInvoke *desc = [[XTransactionDescInvoke alloc] init];
    desc.authRequires = authRequires;
    desc.moduleName = @"wasm";
    desc.contractName = contractName;
    desc.methodName = methodName;
    desc.args = args;

    XTransactionOpt *opt = [XTransactionOpt optWasmInvokeWithAddress:address invokeDesc:desc forzenHeight:forzenHeight];
    
    /// 计算手续费
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
                
                if ( error ) {
                    return handle(false, error);
                }
                       
                if ( !error && !response ) {
                    return handle(false, self.errorRequestNoErrorResponseInvaild);
                }
                
                if ( response.header.error != XChainErrorEnum_Success ) {
                    return handle(false, [self errorResponseWithCode:response.header.error]);
                }
                
                handle(tx.txid.xHexString, nil);
            }];
            
        }];
        
    }];
}

- (void) queryWithAddress:(XAddress _Nonnull)address
             authRequires:(NSArray<XAddress> * _Nonnull)authRequires
             contractName:(NSString * _Nonnull)contractName
               methodName:(NSString * _Nonnull)methodName
                     args:(NSDictionary<NSString*, NSString*> * _Nullable)args
                   handle:(XServicesResponseInvoke _Nonnull)handle {
    
    
    XTransactionDescInvoke *desc = [[XTransactionDescInvoke alloc] init];
    desc.authRequires = authRequires;
    desc.moduleName = @"wasm";
    desc.contractName = contractName;
    desc.methodName = methodName;
    desc.args = args;

    XTransactionOpt *opt = [XTransactionOpt optWasmInvokeWithAddress:address invokeDesc:desc forzenHeight:0];
    
    [self preExecOpt:opt handle:handle];
}

@end
