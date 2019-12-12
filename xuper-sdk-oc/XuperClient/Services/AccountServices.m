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
if ( (rsp).header.error != XChainErrorEnum_Success ) {\
    return handle(nil, [XError xErrorTransactionContextRPCWithCode:rsp.header.error]);\
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

- (id<XCryptoKeypairProtocol> _Nonnull) newKeysWithCryptoType:(XCryptoTypeStringKey _Nullable)type {
    
    if (!type) {
        type = XCryptoTypeStringKeyDefault;
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

- (void) newAccountWithAddress:(XAddress _Nonnull)address
                   accountName:(unsigned char[_Nullable 18])accountName
                           acl:(XTransactionACL * _Nonnull)acl
                 initorKeypair:(id<XCryptoKeypairProtocol> _Nonnull)keypiar
                      feeAsker:(XServicesResponseFeeAsker _Nullable)feeAsker
                        handle:(XServicesResponseCommonReply _Nonnull)handle {
    
    __block XTransactionOpt *opt;
    __block XAccount xacc;
    
    NSError *error;
    
    if ( accountName ) {
        
        opt = [XTransactionOpt optNewAccountWithAddress:address accountName:accountName acl:acl error:&error];
        xacc = [NSString stringWithFormat:@"XC%s@%@", accountName, self.blockChainName];
        
    } else {
        
        NSString *randomedAddress;
        opt = [XTransactionOpt optNewAccountWithAddress:address acl:acl randomAccount:&randomedAddress error:&error];
        xacc = [NSString stringWithFormat:@"XC%@@%@", randomedAddress, self.blockChainName];
    }
    
    if ( [opt.desc isKindOfClass:[XTransactionDescInvoke class]] ) {
        
        [self preExecInvokesWithInitor:address invokes:@[((XTransactionDescInvoke*)opt.desc).invokeRequest] authrequires:opt.desc.authRequires handle:^(InvokeResponse * _Nullable response, NSError * _Nullable error) {
            
            BOOL alwaysSend = true;
            opt.fee = [[XBigInt alloc] initWithUInt:response.gasUsed];
            if ( feeAsker ) {
                alwaysSend = feeAsker( opt.fee );
            }
            
            if (!alwaysSend) {
                return handle(nil, nil, XError.xErrorAksFeeReject);
            }
            
            /// 添加手续费后发送
            [XTransactionBuilder trsanctionWithClient:self.clientRef
                                               option:opt
                                       ignoreFeeCheck:NO
                                        initorKeypair:keypiar
                                  authRequireKeypairs:@[keypiar]
                                               handle:^(Transaction * _Nullable tx, NSError * _Nullable error) {
                
                if ( error ) {
                    return handle(nil, nil, error);
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

                    if ( response.header.error != XChainErrorEnum_Success ) {
                        return handle(nil, nil, [XError xErrorTransactionContextRPCWithCode:response.header.error]);
                    }
                    
                    XHexString hash = tx.txid.xHexString;
                    handle(xacc, hash, nil);
                }];
                
            }];
        }];
        
    }
    
}

- (void) newAccountWithAddress:(XAddress _Nonnull)address
                           acl:(XTransactionACL * _Nonnull)acl
                 initorKeypair:(id<XCryptoKeypairProtocol> _Nonnull)keypiar
                      feeAsker:(XServicesResponseFeeAsker _Nullable)feeAsker
                        handle:(XServicesResponseCommonReply _Nonnull)handle {
    
    return [self newAccountWithAddress:address accountName:nil acl:acl initorKeypair:keypiar
                              feeAsker:feeAsker
                                handle:handle];
}

@end
