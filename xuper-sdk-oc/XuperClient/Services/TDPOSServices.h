//
//  TDPOSServices.h
//  xuper-sdk-oc-iOS
//
//  Created by apple on 2019/12/12.
//  Copyright © 2019 Martin.Ren. All rights reserved.
//

#import "AbstractServices.h"

@interface TDPOSServices : AbstractServices

- (void) queryCandidatesWithHandle:(XServicesResponseList _Nonnull)handle;

- (void) queryCheckResultWithHandle:(XServicesResponseNumber _Nonnull)handle;

- (void) queryNominateRecordsWithAddress:(XAddress _Nonnull)address handle:(XServicesResponseNominateInfoArray _Nonnull)handle;

- (void) queryNomineeRecordWithHandle:(XServicesResponseHash _Nonnull)handle;

- (void) queryVoteRecordsWithAddress:(XAddress _Nonnull)address handle:(XServicesResponseVoteRecords _Nonnull)handle;

- (void) queryVotedRecordsWithAddress:(XAddress _Nonnull)address handle:(XServicesResponseVotedRecords _Nonnull)handle;

- (void) statusWithHandle:(XServicesResponseDposStatus _Nonnull)handle;

@end
