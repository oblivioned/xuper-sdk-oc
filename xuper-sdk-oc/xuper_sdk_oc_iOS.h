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
#import <xuper_sdk_oc_iOS/NSMutableData+xCodeable.h>
#import <xuper_sdk_oc_iOS/XBigInt.h>

/// Protocol
#import <xuper_sdk_oc_iOS/XCryptoPubKeyProtocol.h>
#import <xuper_sdk_oc_iOS/XCryptoPrivKeyProtocol.h>
#import <xuper_sdk_oc_iOS/XCryptoKeypairProtocol.h>

#import <xuper_sdk_oc_iOS/XCryptoAccountProtocol.h>
#import <xuper_sdk_oc_iOS/XCryptoClientProtocol.h>

/// Message ext
#import <xuper_sdk_oc_iOS/Transaction+SDKExtension.h>
#import <xuper_sdk_oc_iOS/GPBMessage+RandomHeader.h>

/// Crypto client Factory
#import <xuper_sdk_oc_iOS/XCryptoFactory.h>

/// ECDSA implement
#import <xuper_sdk_oc_iOS/XECDSAPubKey.h>
#import <xuper_sdk_oc_iOS/XECDSAPrivKey.h>
#import <xuper_sdk_oc_iOS/XECDSAAccount.h>
#import <xuper_sdk_oc_iOS/XECDSAClient.h>

/// Protocbuff message obj
#import <xuper_sdk_oc_iOS/Chainedbft.pbobjc.h>
#import <xuper_sdk_oc_iOS/Xchain.pbobjc.h>
#import <xuper_sdk_oc_iOS/XchainSpv.pbobjc.h>
#import <xuper_sdk_oc_iOS/Xcheck.pbobjc.h>
#import <xuper_sdk_oc_iOS/Xendorser.pbobjc.h>

/// XProvider
#import <xuper_sdk_oc_iOS/XProviderConfigure.h>
#import <xuper_sdk_oc_iOS/XProviderProtocol.h>

/// XClient
#import <xuper_sdk_oc_iOS/XClient.h>

/// XTransaction
#import <xuper_sdk_oc_iOS/XGlobalFlags.h>
#import <xuper_sdk_oc_iOS/XTransactionBuilder.h>
#import <xuper_sdk_oc_iOS/XTransactionOpt.h>
#import <xuper_sdk_oc_iOS/XTransactionACL.h>
#import <xuper_sdk_oc_iOS/XTransactionDesc.h>
#import <xuper_sdk_oc_iOS/XTransactionDescInvoke.h>

/// Opts category
#import <xuper_sdk_oc_iOS/XTransactionOpt+Transfer.h>
#import <xuper_sdk_oc_iOS/XTransactionOpt+NewAccount.h>
#import <xuper_sdk_oc_iOS/XTransactionOpt+Contracts.h>

/// XuperClien
#import <xuper_sdk_oc_iOS/XuperClient.h>
#import <xuper_sdk_oc_iOS/AccountServices.h>
#import <xuper_sdk_oc_iOS/ACLServices.h>
#import <xuper_sdk_oc_iOS/BlockServices.h>
#import <xuper_sdk_oc_iOS/MultisigServices.h>
