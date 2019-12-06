//
//  AccountServices.m
//  xuper-sdk-oc-iOS
//
//  Created by apple on 2019/12/6.
//  Copyright © 2019 Martin.Ren. All rights reserved.
//

#import "AccountServices.h"
#import "XCryptoFactory.h"

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

@end
