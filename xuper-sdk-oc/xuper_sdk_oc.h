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
#import <xuper_sdk_oc/XCommon.h>

#import <xuper_sdk_oc/NSData+xCodeable.h>
#import <xuper_sdk_oc/NSString+xCodeable.h>

/// Protocol
#import <xuper_sdk_oc/XCryptoPubKeyProtocol.h>
#import <xuper_sdk_oc/XCryptoPrivKeyProtocol.h>
#import <xuper_sdk_oc/XCryptoKeypairProtocol.h>

#import <xuper_sdk_oc/XCryptoAccountProtocol.h>
#import <xuper_sdk_oc/XCryptoClientProtocol.h>

#import <xuper_sdk_oc/XCryptoFactory.h>

// ECDSA implement
#import <xuper_sdk_oc/XECDSAPubKey.h>
#import <xuper_sdk_oc/XECDSAPrivKey.h>
#import <xuper_sdk_oc/XECDSAAccount.h>
#import <xuper_sdk_oc/XECDSAClient.h>
