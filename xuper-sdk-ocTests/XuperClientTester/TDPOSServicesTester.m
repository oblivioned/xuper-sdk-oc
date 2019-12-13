//
//  TDPOSServicesTester.m
//  xuper-sdk-oc-iOSTests
//
//  Created by apple on 2019/12/12.
//  Copyright © 2019 Martin.Ren. All rights reserved.
//

#import "TestCommon.h"

@interface TDPOSServicesTester : XCTestCase

@end

@implementation TDPOSServicesTester


- (void)test_QueryCandidates { AsyncTestBegin(@"TDPOSServices - QueryCandidates");
    
    [T.xuperClient.tdpos queryCandidatesWithHandle:^(NSArray * _Nullable response, NSError * _Nullable error) {
        XCTAssertNotNil(response);
        XCTAssertNil(error);
        AsyncTestFulfill();
    }];
    
AsyncTestWaiting5S(); }


- (void)test_CheckResult { AsyncTestBegin(@"TDPOSServices - CheckResult");
    
    [T.xuperClient.tdpos queryCheckResultWithHandle:^(NSInteger num, NSError * _Nullable error) {
        XCTAssertNil(error);
        AsyncTestFulfill();
    }];
    
AsyncTestWaiting5S(); }


- (void)test_QueryNominateRecords { AsyncTestBegin(@"TDPOSServices - QueryNominateRecords");
    
    [T.xuperClient.tdpos queryNominateRecordsWithAddress:T.initor.address handle:^(NSArray<DposNominateInfo *> * _Nullable list, NSError * _Nullable error) {
        XCTAssertNil(error);
        AsyncTestFulfill();
    }];
    
AsyncTestWaiting5S(); }


- (void) test_QueryNomineeRecord { AsyncTestBegin(@"TDPOSServices - NomineeRecord");
    
    [T.xuperClient.tdpos queryNomineeRecordWithHandle:^(XHexString  _Nullable txhash, NSError * _Nullable error) {
        XCTAssertNil(error);
        AsyncTestFulfill();
    }];
    
AsyncTestWaiting5S(); }


- (void) test_QueryVoteRecords { AsyncTestBegin(@"TDPOSServices - VoteRecords");
    
    [T.xuperClient.tdpos queryVoteRecordsWithAddress:T.initor.address handle:^(NSArray<voteRecord *> * _Nullable list, NSError * _Nullable error) {
        XCTAssertNil(error);
        AsyncTestFulfill();
    }];
    
AsyncTestWaiting5S(); }


- (void) test_QueryVotedRecords { AsyncTestBegin(@"TDPOSServices - VotedRecords");
    
    [T.xuperClient.tdpos queryVotedRecordsWithAddress:T.initor.address handle:^(NSArray<votedRecord *> * _Nullable list, NSError * _Nullable error) {
        XCTAssertNil(error);
        AsyncTestFulfill();
    }];
    
AsyncTestWaiting5S(); }



- (void) test_Status { AsyncTestBegin(@"TDPOSServices - Status");

    [T.xuperClient.tdpos statusWithHandle:^(DposStatus * _Nullable status, NSError * _Nullable error) {
        XCTAssertNil(error);
        AsyncTestFulfill();
    }];
    
AsyncTestWaiting5S(); }

@end
