//
//  TDPOSServices.m
//  xuper-sdk-oc-iOS
//
//  Created by apple on 2019/12/12.
//  Copyright © 2019 Martin.Ren. All rights reserved.
//

#import "TDPOSServices.h"

#define XHandleTDPOSServicesError(handle, rsp, err)\
if ( (err) ) {\
    return handle(nil, (err));\
}\
if ( (rsp).header.error != XChainErrorEnum_Success ) {\
    return handle(nil, [XError xErrorTransactionContextRPCWithCode:rsp.header.error]);\
}

@implementation TDPOSServices

- (void) queryCandidatesWithHandle:(XServicesResponseList _Nonnull)handle {
    
    DposCandidatesRequest *message = DposCandidatesRequest.message;
    message.header = DposCandidatesRequest.getRandomHeader;
    message.bcname = self.blockChainName;
    
    [self.clientRef dposCandidatesWithRequest:message handler:^(DposCandidatesResponse * _Nullable response, NSError * _Nullable error) {
       
        XHandleTDPOSServicesError(handle, response, error);
        
        return handle( response.candidatesInfoArray, nil );
        
    }];
}

- (void) queryCheckResultWithHandle:(XServicesResponseNumber _Nonnull)handle {
    
    DposCheckResultsRequest *message = DposCheckResultsRequest.message;
    message.header = DposCheckResultsRequest.getRandomHeader;
    message.bcname = self.blockChainName;
    
    [self.clientRef dposCheckResultsWithRequest:message handler:^(DposCheckResultsResponse * _Nullable response, NSError * _Nullable error) {
       
        if ( error ) {
            return handle(0, error);
        }
        
        if ( response.header.error != XChainErrorEnum_Success ) {
            return handle(0, [XError xErrorTransactionContextRPCWithCode:response.header.error]);
        }
        
        return handle(response.term, nil);
    }];
    
}

- (void) queryNominateRecordsWithAddress:(XAddress _Nonnull)address handle:(XServicesResponseNominateInfoArray _Nonnull)handle {
    
    DposNominateRecordsRequest *message = DposNominateRecordsRequest.message;
    message.header = DposNominateRecordsRequest.getRandomHeader;
    message.bcname = self.blockChainName;
    message.address = address;
    
    [self.clientRef dposNominateRecordsWithRequest:message handler:^(DposNominateRecordsResponse * _Nullable response, NSError * _Nullable error) {
       
        XHandleTDPOSServicesError(handle, response, error);
        
        return handle(response.nominateRecordsArray, nil);
    }];
    
}

- (void) queryNomineeRecordWithHandle:(XServicesResponseHash _Nonnull)handle {
    
    DposNomineeRecordsRequest *message = DposNomineeRecordsRequest.message;
    message.header = DposCheckResultsRequest.getRandomHeader;
    message.bcname = self.blockChainName;
    
    [self.clientRef dposNomineeRecordsWithRequest:message handler:^(DposNomineeRecordsResponse * _Nullable response, NSError * _Nullable error) {
        
        XHandleTDPOSServicesError(handle, response, error);
        
        return handle(response.txid, nil);
    }];
}

- (void) queryVoteRecordsWithAddress:(XAddress _Nonnull)address handle:(XServicesResponseVoteRecords _Nonnull)handle {
    
    DposVoteRecordsRequest *message = DposVoteRecordsRequest.message;
    message.header = DposVoteRecordsRequest.getRandomHeader;
    message.bcname = self.blockChainName;
    message.address = address;
    
    [self.clientRef dposVoteRecordsWithRequest:message handler:^(DposVoteRecordsResponse * _Nullable response, NSError * _Nullable error) {
       
        XHandleTDPOSServicesError(handle, response, error);
        
        return handle(response.voteTxidRecordsArray, nil);
    }];
}

- (void) queryVotedRecordsWithAddress:(XAddress _Nonnull)address handle:(XServicesResponseVotedRecords _Nonnull)handle {
    
    DposVotedRecordsRequest *message = DposVotedRecordsRequest.message;
    message.header = DposVotedRecordsRequest.getRandomHeader;
    message.bcname = self.blockChainName;
    message.address = address;
    
    [self.clientRef dposVotedRecordsWithRequest:message handler:^(DposVotedRecordsResponse * _Nullable response, NSError * _Nullable error) {
        
        XHandleTDPOSServicesError(handle, response, error);
        
        return handle(response.votedTxidRecordsArray, nil);
    }];
    
}

- (void) statusWithHandle:(XServicesResponseDposStatus _Nonnull)handle {
    
    DposStatusRequest *message = DposStatusRequest.message;
    message.header = DposVotedRecordsRequest.getRandomHeader;
    message.bcname = self.blockChainName;
    
    [self.clientRef dposStatusWithRequest:message handler:^(DposStatusResponse * _Nullable response, NSError * _Nullable error) {
        
        XHandleTDPOSServicesError(handle, response, error);
        
        return handle(response.status, nil);
    }];
    
}

@end
