//
//  xuper_sdk_oc.h
//  xuper-sdk-oc
//
//  Created by apple on 2019/11/29.
//  Copyright © 2019 Martin.Ren. All rights reserved.
//

#import <Foundation/Foundation.h>

//! Project version number for xuper_sdk_oc.
FOUNDATION_EXPORT double xuper_sdk_ocVersionNumber;

//! Project version string for xuper_sdk_oc.
FOUNDATION_EXPORT const unsigned char xuper_sdk_ocVersionString[];

/// In this header, you should import all the public headers of your framework using statements like #import <xuper_sdk_oc/PublicHeader.h>
#import <xuper_sdk_oc_iOS/XCommon.h>

#import <xuper_sdk_oc_iOS/NSData+xCodeable.h>
#import <xuper_sdk_oc_iOS/NSString+xCodeable.h>

/// Protocol
#import <xuper_sdk_oc_iOS/XCryptoPubKeyProtocol.h>
#import <xuper_sdk_oc_iOS/XCryptoPrivKeyProtocol.h>
#import <xuper_sdk_oc_iOS/XCryptoKeypairProtocol.h>

#import <xuper_sdk_oc_iOS/XCryptoAccountProtocol.h>
#import <xuper_sdk_oc_iOS/XCryptoClientProtocol.h>

#import <xuper_sdk_oc_iOS/XCryptoFactory.h>

// ECDSA implement
#import <xuper_sdk_oc_iOS/XECDSAPubKey.h>
#import <xuper_sdk_oc_iOS/XECDSAPrivKey.h>
#import <xuper_sdk_oc_iOS/XECDSAAccount.h>
#import <xuper_sdk_oc_iOS/XECDSAClient.h>
