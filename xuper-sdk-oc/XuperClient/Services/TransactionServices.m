//
//  TransactionServices.m
//  xuper-sdk-oc-iOS
//
//  Created by apple on 2019/12/10.
//  Copyright © 2019 Martin.Ren. All rights reserved.
//

#import "TransactionServices.h"
#import "NSString+xCodeable.h"

@implementation TransactionServices

- (void) queryWithTXID:(XHexString _Nonnull)txid handle:(XServicesResponseTransaction _Nonnull)handle {
    
    TxStatus *tx_status = TxStatus.message;
    tx_status.header = TxStatus.getRandomHeader;
    tx_status.bcname = self.blockChainName;
    tx_status.txid = txid.xHexStringData;
    
    [self.clientRef queryTxWithRequest:tx_status handler:^(TxStatus * _Nullable response, NSError * _Nullable error) {
        
        if ( error ) {
            return handle(nil, error);
        }

        if ( !error && !response ) {
            return handle(nil, self.errorRequestNoErrorResponseInvaild);
        }

        if ( response.header.error != XChainErrorEnum_Success ) {
            return handle(nil, [self errorResponseWithCode:response.header.error]);
        }

        handle(response.tx, nil);
        
    }];
    
}

@end
