//
//  XTransactionACL.h
//  xuper-sdk-oc-iOS
//
//  Created by apple on 2019/12/7.
//  Copyright © 2019 Martin.Ren. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XCommon.h"
#import "Xchain.pbobjc.h"

typedef NS_ENUM(NSUInteger, XTransactionPMRule) {
    XTransactionPMRuleDefault = 1,
};

typedef NSMutableDictionary<XAddress, NSNumber*> XTransactionAKSWeight;


@interface XTransactionPM : NSObject

@property (nonatomic, assign) XTransactionPMRule rule;
@property (nonatomic, assign) float acceptValue;
@end


@interface XTransactionACL : NSObject <XTransactionJsonEncodeable>
@property (nonatomic, strong) XTransactionPM * _Nonnull pm;
@property (nonatomic, strong) XTransactionAKSWeight * _Nonnull aksWeight;

- (NSString * _Nullable) aclAuthRequireString;

- (instancetype _Nonnull) initWithPBACL:(Acl* _Nonnull)acl;

+ (instancetype _Nonnull) simpleACLWithAddress:(XAddress _Nonnull)address;

@end
