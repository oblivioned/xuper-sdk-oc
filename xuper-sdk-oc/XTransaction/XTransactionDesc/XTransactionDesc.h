//
//  XTransactionDesc.h
//  xuper-sdk-oc-iOS
//
//  Created by apple on 2019/12/6.
//  Copyright © 2019 Martin.Ren. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XCommon.h"
#import "XTransactionDesc.h"

@interface XTransactionDesc: NSObject

@property (nonatomic, copy)NSArray<NSString*> * _Nullable authRequires;

+ (instancetype _Nullable)descWithString:(NSString * _Nullable)string;

- (NSData * _Nonnull)encodeToData;

@end


@interface XTransactionDescString: XTransactionDesc

@property (nonatomic, copy)NSString * _Nullable string;

- (NSData * _Nonnull)encodeToData;

@end


