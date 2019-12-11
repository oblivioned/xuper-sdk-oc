//
//  TransferServices.m
//  xuper-sdk-oc-iOS
//
//  Created by apple on 2019/12/9.
//  Copyright © 2019 Martin.Ren. All rights reserved.
//

#import "TransferServices.h"

@implementation TransferServices

- (void) transferWithFrom:(XAddress _Nonnull)from
                       to:(XAddress _Nonnull)toAddr
                   amount:(XBigInt * _Nonnull)amount
                  remarks:(NSString * _Nullable)remarks
             forzenHeight:(NSInteger)forzenHeight
            initorKeypair:(id<XCryptoKeypairProtocol> _Nonnull)initorKeypair
      authRequireKeypairs:(NSArray<id<XCryptoKeypairProtocol>> *_Nullable)authRequireKeypairs
                   handle:(XServicesResponseHash _Nonnull)handle {
    
    XTransactionOpt *opt = [XTransactionOpt optTransferWithFrom:from
                                                             to:toAddr
                                                         amount:amount
                                                        remarks:remarks
                                                   forzenHeight:forzenHeight];

    [XTransactionBuilder trsanctionWithClient:self.clientRef
                                       option:opt
                               ignoreFeeCheck:NO
                                initorKeypair:initorKeypair
                          authRequireKeypairs:authRequireKeypairs
                                       handle:^(Transaction * _Nullable tx, NSError * _Nullable error) {

        if ( error ) {
            return handle(nil, error);
        }

        if ( !error && !tx ) {
            return handle(nil, self.errorRequestNoErrorResponseInvaild);
        }

        TxStatus *tx_status = TxStatus.message;
        tx_status.header = TxStatus.getRandomHeader;
        tx_status.bcname = self.blockChainName;
        tx_status.status = TransactionStatus_Unconfirm;
        tx_status.tx = tx;
        tx_status.txid = tx.txid;

        [self.clientRef postTxWithRequest:tx_status handler:^(CommonReply * _Nullable response, NSError * _Nullable error) {

            if ( error ) {
                return handle(nil, error);
            }

            if ( !error && !tx ) {
                return handle(nil, self.errorRequestNoErrorResponseInvaild);
            }

            if ( response.header.error != XChainErrorEnum_Success ) {
                return handle(nil, [self errorResponseWithCode:response.header.error]);
            }

            handle(tx_status.txid.xHexString, nil);
        }];

    }];
}

- (void) transferWithFrom:(XAddress _Nonnull)from
                       to:(XAddress _Nonnull)toAddr
                   amount:(XBigInt * _Nonnull)amount
            initorKeypair:(id<XCryptoKeypairProtocol> _Nonnull)initorKeypair
                   handle:(XServicesResponseHash _Nonnull)handle {
    
    [self transferWithFrom:from
                        to:toAddr
                    amount:amount
                   remarks:nil
              forzenHeight:0
             initorKeypair:initorKeypair
       authRequireKeypairs:@[initorKeypair] handle:handle];
}

@end

