//
//  AccountServices.m
//  xuper-sdk-oc-iOS
//
//  Created by apple on 2019/12/6.
//  Copyright © 2019 Martin.Ren. All rights reserved.
//

#import "AccountServices.h"
#import "XCryptoFactory.h"
#import "XTransactionBuilder.h"
#import "XTransactionOpt+NewAccount.h"
#import "NSData+xCodeable.h"

#define XHandleAccountServicesError(handle, rsp, err)\
if ( (err) ) {\
    return handle(nil, (err));\
}\
if ( !(err) && !(rsp) ) {\
    return handle(nil, self.errorRequestNoErrorResponseInvaild);\
}\
if ( (rsp).header.error != XChainErrorEnum_Success ) {\
    return handle(nil, [self errorResponseWithCode:response.header.error]);\
}

@implementation AccountServices

- (void) balanceWithAddress:(XAddress _Nonnull)addr handle:(XServicesResponseBigInt _Nonnull)handle {
    
    AddressStatus *message = AddressStatus.message;
    
    message.header = AddressBalanceStatus.getRandomHeader;
    
    message.address = addr;
    
    
    TokenDetail *detail = [TokenDetail message];
    
    detail.bcname = self.blockChainName;
    
    [message.bcsArray addObject:detail];
    
    [self.clientRef getBalanceWithRequest:message handler:^(AddressStatus * _Nullable response, NSError * _Nullable error) {

        XHandleAccountServicesError(handle, response, error);
        
        XBigInt *balance = [[XBigInt alloc] initWithDecString:response.bcsArray.firstObject.balance];
        
        handle(balance, nil);
    }];
}

- (void) balanceFrozenWithAddress:(XAddress _Nonnull)addr handle:(XServicesResponseBigInt _Nonnull)handle {
    
    AddressStatus *message = AddressStatus.message;
    
    message.header = AddressBalanceStatus.getRandomHeader;
    
    message.address = addr;
    
    
    TokenDetail *detail = [TokenDetail message];
    
    detail.bcname = self.blockChainName;
    
    [message.bcsArray addObject:detail];
    
    [self.clientRef getFrozenBalanceWithRequest:message handler:^(AddressStatus * _Nullable response, NSError * _Nullable error) {
        
        XHandleAccountServicesError(handle, response, error);
        
        XBigInt *balance = [[XBigInt alloc] initWithDecString:response.bcsArray.firstObject.balance];
        
        handle(balance, nil);
        
    }];
    
}

- (void) contractsWithAccount:(XAccount _Nonnull)acc handle:(XServicesResponseContracts _Nonnull)handle {
    
    GetAccountContractsRequest *message = GetAccountContractsRequest.message;
    
    message.header = GetAccountContractsRequest.getRandomHeader;
    
    message.bcname = self.blockChainName;
    
    message.account = acc;
    
    [self.clientRef getAccountContractsWithRequest:message handler:^(GetAccountContractsResponse * _Nullable response, NSError * _Nullable error) {
        
        XHandleAccountServicesError(handle, response, error);
        
        handle(response.contractsStatusArray, nil);
        
    }];
    
}

- (id<XCryptoKeypairProtocol> _Nonnull) newKeysWithCryptoType:(XSDKEnumCryptoTypeStringKey _Nullable)type {
    
    if (!type) {
        type = XSDKEnumCryptoTypeStringKeyDefault;
    }
    
    id<XCryptoClientProtocol> cryptoClient = [XCryptoFactory cryptoClientWithCryptoType:type];

    return [cryptoClient generateKey];
}

- (void) queryAccountListWithAddress:(XAddress _Nonnull)addr handle:(XServicesResponseAccounts _Nonnull)handle {
    
    AK2AccountRequest *message = AK2AccountRequest.message;
    
    message.header = AK2AccountRequest.getRandomHeader;
    
    message.bcname = self.blockChainName;
    
    message.address = addr;
    
    [self.clientRef getAccountByAKWithRequest:message handler:^(AK2AccountResponse * _Nullable response, NSError * _Nullable error) {
       
        XHandleAccountServicesError(handle, response, error);
        
        handle(response.accountArray, nil);
        
    }];
    
}

- (void) newAccountWithAddress:(XAddress _Nonnull)address accountName:(unsigned char[_Nullable 18])accountName acl:(XTransactionACL * _Nonnull)acl initorKeypair:(id<XCryptoKeypairProtocol> _Nonnull)keypiar fee:(XBigInt * _Nonnull)fee handle:(XServicesResponseCommonReply _Nonnull)handle {
    
    __block XTransactionOpt *opt;
    
    NSError *error;
    
    if ( accountName ) {
        opt = [XTransactionOpt newAccountOptWithAddress:address accountName:accountName acl:acl error:&error];
    } else {
        opt = [XTransactionOpt newAccountOptWithAddress:address acl:acl error:&error];
    }
    opt.fee = fee;
    
    if (error) {
        handle(nil, nil, error);
    }
    
    [XTransactionBuilder buildTrsanctionWithClient:self.clientRef
                                            option:opt
                                     initorKeypair:keypiar
                               authRequireKeypairs:@[keypiar]
                                            handle:^(Transaction * _Nullable tx, NSError * _Nullable error) {
        
        if ( error ) {
            return handle(nil, nil, error);
        }
        
        if ( !error && !tx ) {
            return handle(nil, nil, self.errorRequestNoErrorResponseInvaild);
        }
        
        TxStatus *tx_status = TxStatus.message;
        tx_status.header = TxStatus.getRandomHeader;
        tx_status.bcname = self.blockChainName;
        tx_status.status = TransactionStatus_Unconfirm;
        tx_status.tx = tx;
        tx_status.txid = tx.txid;
        
        [self.clientRef postTxWithRequest:tx_status handler:^(CommonReply * _Nullable response, NSError * _Nullable error) {
            
            if ( error ) {
                return handle(nil, nil, error);
            }
                   
            if ( !error && !tx ) {
                return handle(nil, nil, self.errorRequestNoErrorResponseInvaild);
            }
            
            if ( response.header.error != XChainErrorEnum_Success ) {
                return handle(nil, nil, [self errorResponseWithCode:response.header.error]);
            }
            
            XHexString hash = tx.txid.xHexString;
            
            handle(@"accountname", hash, nil);

        }];
        
    }];
    
}


- (void) newAccountWithAddress:(XAddress _Nonnull)address acl:(XTransactionACL * _Nonnull)acl initorKeypair:(id<XCryptoKeypairProtocol> _Nonnull)keypiar fee:(XBigInt * _Nonnull)fee handle:(XServicesResponseCommonReply _Nonnull)handle {
    return [self newAccountWithAddress:address accountName:nil acl:acl initorKeypair:keypiar fee:fee handle:handle];
}

@end
