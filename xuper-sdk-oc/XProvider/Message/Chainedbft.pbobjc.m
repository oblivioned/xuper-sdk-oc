// Generated by the protocol buffer compiler.  DO NOT EDIT!
// source: chainedbft.proto

// This CPP symbol can be defined to use imports that match up to the framework
// imports needed when using CocoaPods.
#if !defined(GPB_USE_PROTOBUF_FRAMEWORK_IMPORTS)
 #define GPB_USE_PROTOBUF_FRAMEWORK_IMPORTS 0
#endif

#if GPB_USE_PROTOBUF_FRAMEWORK_IMPORTS
 #import <Protobuf/GPBProtocolBuffers_RuntimeSupport.h>
#else
 #import "GPBProtocolBuffers_RuntimeSupport.h"
#endif

#import <stdatomic.h>

#import "Chainedbft.pbobjc.h"
// @@protoc_insertion_point(imports)

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"

#pragma mark - ChainedbftRoot

@implementation ChainedbftRoot

// No extensions in the file and no imports, so no need to generate
// +extensionRegistry.

@end

#pragma mark - ChainedbftRoot_FileDescriptor

static GPBFileDescriptor *ChainedbftRoot_FileDescriptor(void) {
  // This is called by +initialize so there is no need to worry
  // about thread safety of the singleton.
  static GPBFileDescriptor *descriptor = NULL;
  if (!descriptor) {
    GPB_DEBUG_CHECK_RUNTIME_VERSIONS();
    descriptor = [[GPBFileDescriptor alloc] initWithPackage:@"pb"
                                                     syntax:GPBFileSyntaxProto3];
  }
  return descriptor;
}

#pragma mark - Enum QCState

GPBEnumDescriptor *QCState_EnumDescriptor(void) {
  static _Atomic(GPBEnumDescriptor*) descriptor = nil;
  if (!descriptor) {
    static const char *valueNames =
        "NewView\000Prepare\000PreCommit\000Commit\000Decide\000";
    static const int32_t values[] = {
        QCState_NewView,
        QCState_Prepare,
        QCState_PreCommit,
        QCState_Commit,
        QCState_Decide,
    };
    GPBEnumDescriptor *worker =
        [GPBEnumDescriptor allocDescriptorForName:GPBNSStringifySymbol(QCState)
                                       valueNames:valueNames
                                           values:values
                                            count:(uint32_t)(sizeof(values) / sizeof(int32_t))
                                     enumVerifier:QCState_IsValidValue];
    GPBEnumDescriptor *expected = nil;
    if (!atomic_compare_exchange_strong(&descriptor, &expected, worker)) {
      [worker release];
    }
  }
  return descriptor;
}

BOOL QCState_IsValidValue(int32_t value__) {
  switch (value__) {
    case QCState_NewView:
    case QCState_Prepare:
    case QCState_PreCommit:
    case QCState_Commit:
    case QCState_Decide:
      return YES;
    default:
      return NO;
  }
}

#pragma mark - QuorumCert

@implementation QuorumCert

@dynamic proposalId;
@dynamic proposalMsg;
@dynamic type;
@dynamic viewNumber;
@dynamic hasSignInfos, signInfos;

typedef struct QuorumCert__storage_ {
  uint32_t _has_storage_[1];
  QCState type;
  NSData *proposalId;
  NSData *proposalMsg;
  QCSignInfos *signInfos;
  int64_t viewNumber;
} QuorumCert__storage_;

// This method is threadsafe because it is initially called
// in +initialize for each subclass.
+ (GPBDescriptor *)descriptor {
  static GPBDescriptor *descriptor = nil;
  if (!descriptor) {
    static GPBMessageFieldDescription fields[] = {
      {
        .name = "proposalId",
        .dataTypeSpecific.className = NULL,
        .number = QuorumCert_FieldNumber_ProposalId,
        .hasIndex = 0,
        .offset = (uint32_t)offsetof(QuorumCert__storage_, proposalId),
        .flags = (GPBFieldFlags)(GPBFieldOptional | GPBFieldTextFormatNameCustom),
        .dataType = GPBDataTypeBytes,
      },
      {
        .name = "proposalMsg",
        .dataTypeSpecific.className = NULL,
        .number = QuorumCert_FieldNumber_ProposalMsg,
        .hasIndex = 1,
        .offset = (uint32_t)offsetof(QuorumCert__storage_, proposalMsg),
        .flags = (GPBFieldFlags)(GPBFieldOptional | GPBFieldTextFormatNameCustom),
        .dataType = GPBDataTypeBytes,
      },
      {
        .name = "type",
        .dataTypeSpecific.enumDescFunc = QCState_EnumDescriptor,
        .number = QuorumCert_FieldNumber_Type,
        .hasIndex = 2,
        .offset = (uint32_t)offsetof(QuorumCert__storage_, type),
        .flags = (GPBFieldFlags)(GPBFieldOptional | GPBFieldTextFormatNameCustom | GPBFieldHasEnumDescriptor),
        .dataType = GPBDataTypeEnum,
      },
      {
        .name = "viewNumber",
        .dataTypeSpecific.className = NULL,
        .number = QuorumCert_FieldNumber_ViewNumber,
        .hasIndex = 3,
        .offset = (uint32_t)offsetof(QuorumCert__storage_, viewNumber),
        .flags = (GPBFieldFlags)(GPBFieldOptional | GPBFieldTextFormatNameCustom),
        .dataType = GPBDataTypeInt64,
      },
      {
        .name = "signInfos",
        .dataTypeSpecific.className = GPBStringifySymbol(QCSignInfos),
        .number = QuorumCert_FieldNumber_SignInfos,
        .hasIndex = 4,
        .offset = (uint32_t)offsetof(QuorumCert__storage_, signInfos),
        .flags = (GPBFieldFlags)(GPBFieldOptional | GPBFieldTextFormatNameCustom),
        .dataType = GPBDataTypeMessage,
      },
    };
    GPBDescriptor *localDescriptor =
        [GPBDescriptor allocDescriptorForClass:[QuorumCert class]
                                     rootClass:[ChainedbftRoot class]
                                          file:ChainedbftRoot_FileDescriptor()
                                        fields:fields
                                    fieldCount:(uint32_t)(sizeof(fields) / sizeof(GPBMessageFieldDescription))
                                   storageSize:sizeof(QuorumCert__storage_)
                                         flags:GPBDescriptorInitializationFlag_None];
#if !GPBOBJC_SKIP_MESSAGE_TEXTFORMAT_EXTRAS
    static const char *extraTextFormatInfo =
        "\005\001J\000\002K\000\003D\000\004J\000\005I\000";
    [localDescriptor setupExtraTextInfo:extraTextFormatInfo];
#endif  // !GPBOBJC_SKIP_MESSAGE_TEXTFORMAT_EXTRAS
    #if defined(DEBUG) && DEBUG
      NSAssert(descriptor == nil, @"Startup recursed!");
    #endif  // DEBUG
    descriptor = localDescriptor;
  }
  return descriptor;
}

@end

int32_t QuorumCert_Type_RawValue(QuorumCert *message) {
  GPBDescriptor *descriptor = [QuorumCert descriptor];
  GPBFieldDescriptor *field = [descriptor fieldWithNumber:QuorumCert_FieldNumber_Type];
  return GPBGetMessageInt32Field(message, field);
}

void SetQuorumCert_Type_RawValue(QuorumCert *message, int32_t value) {
  GPBDescriptor *descriptor = [QuorumCert descriptor];
  GPBFieldDescriptor *field = [descriptor fieldWithNumber:QuorumCert_FieldNumber_Type];
  GPBSetInt32IvarWithFieldInternal(message, field, value, descriptor.file.syntax);
}

#pragma mark - QCSignInfos

@implementation QCSignInfos

@dynamic qcsignInfosArray, qcsignInfosArray_Count;

typedef struct QCSignInfos__storage_ {
  uint32_t _has_storage_[1];
  NSMutableArray *qcsignInfosArray;
} QCSignInfos__storage_;

// This method is threadsafe because it is initially called
// in +initialize for each subclass.
+ (GPBDescriptor *)descriptor {
  static GPBDescriptor *descriptor = nil;
  if (!descriptor) {
    static GPBMessageFieldDescription fields[] = {
      {
        .name = "qcsignInfosArray",
        .dataTypeSpecific.className = GPBStringifySymbol(SignInfo),
        .number = QCSignInfos_FieldNumber_QcsignInfosArray,
        .hasIndex = GPBNoHasBit,
        .offset = (uint32_t)offsetof(QCSignInfos__storage_, qcsignInfosArray),
        .flags = (GPBFieldFlags)(GPBFieldRepeated | GPBFieldTextFormatNameCustom),
        .dataType = GPBDataTypeMessage,
      },
    };
    GPBDescriptor *localDescriptor =
        [GPBDescriptor allocDescriptorForClass:[QCSignInfos class]
                                     rootClass:[ChainedbftRoot class]
                                          file:ChainedbftRoot_FileDescriptor()
                                        fields:fields
                                    fieldCount:(uint32_t)(sizeof(fields) / sizeof(GPBMessageFieldDescription))
                                   storageSize:sizeof(QCSignInfos__storage_)
                                         flags:GPBDescriptorInitializationFlag_None];
#if !GPBOBJC_SKIP_MESSAGE_TEXTFORMAT_EXTRAS
    static const char *extraTextFormatInfo =
        "\001\001\000QCSignInfos\000";
    [localDescriptor setupExtraTextInfo:extraTextFormatInfo];
#endif  // !GPBOBJC_SKIP_MESSAGE_TEXTFORMAT_EXTRAS
    #if defined(DEBUG) && DEBUG
      NSAssert(descriptor == nil, @"Startup recursed!");
    #endif  // DEBUG
    descriptor = localDescriptor;
  }
  return descriptor;
}

@end

#pragma mark - SignInfo

@implementation SignInfo

@dynamic address;
@dynamic publicKey;
@dynamic sign;

typedef struct SignInfo__storage_ {
  uint32_t _has_storage_[1];
  NSString *address;
  NSString *publicKey;
  NSData *sign;
} SignInfo__storage_;

// This method is threadsafe because it is initially called
// in +initialize for each subclass.
+ (GPBDescriptor *)descriptor {
  static GPBDescriptor *descriptor = nil;
  if (!descriptor) {
    static GPBMessageFieldDescription fields[] = {
      {
        .name = "address",
        .dataTypeSpecific.className = NULL,
        .number = SignInfo_FieldNumber_Address,
        .hasIndex = 0,
        .offset = (uint32_t)offsetof(SignInfo__storage_, address),
        .flags = (GPBFieldFlags)(GPBFieldOptional | GPBFieldTextFormatNameCustom),
        .dataType = GPBDataTypeString,
      },
      {
        .name = "publicKey",
        .dataTypeSpecific.className = NULL,
        .number = SignInfo_FieldNumber_PublicKey,
        .hasIndex = 1,
        .offset = (uint32_t)offsetof(SignInfo__storage_, publicKey),
        .flags = (GPBFieldFlags)(GPBFieldOptional | GPBFieldTextFormatNameCustom),
        .dataType = GPBDataTypeString,
      },
      {
        .name = "sign",
        .dataTypeSpecific.className = NULL,
        .number = SignInfo_FieldNumber_Sign,
        .hasIndex = 2,
        .offset = (uint32_t)offsetof(SignInfo__storage_, sign),
        .flags = (GPBFieldFlags)(GPBFieldOptional | GPBFieldTextFormatNameCustom),
        .dataType = GPBDataTypeBytes,
      },
    };
    GPBDescriptor *localDescriptor =
        [GPBDescriptor allocDescriptorForClass:[SignInfo class]
                                     rootClass:[ChainedbftRoot class]
                                          file:ChainedbftRoot_FileDescriptor()
                                        fields:fields
                                    fieldCount:(uint32_t)(sizeof(fields) / sizeof(GPBMessageFieldDescription))
                                   storageSize:sizeof(SignInfo__storage_)
                                         flags:GPBDescriptorInitializationFlag_None];
#if !GPBOBJC_SKIP_MESSAGE_TEXTFORMAT_EXTRAS
    static const char *extraTextFormatInfo =
        "\003\001G\000\002I\000\003D\000";
    [localDescriptor setupExtraTextInfo:extraTextFormatInfo];
#endif  // !GPBOBJC_SKIP_MESSAGE_TEXTFORMAT_EXTRAS
    #if defined(DEBUG) && DEBUG
      NSAssert(descriptor == nil, @"Startup recursed!");
    #endif  // DEBUG
    descriptor = localDescriptor;
  }
  return descriptor;
}

@end

#pragma mark - ChainedBftPhaseMessage

@implementation ChainedBftPhaseMessage

@dynamic type;
@dynamic viewNumber;
@dynamic hasProposalQc, proposalQc;
@dynamic hasJustifyQc, justifyQc;
@dynamic msgDigest;
@dynamic hasSignature, signature;

typedef struct ChainedBftPhaseMessage__storage_ {
  uint32_t _has_storage_[1];
  QCState type;
  QuorumCert *proposalQc;
  QuorumCert *justifyQc;
  NSData *msgDigest;
  SignInfo *signature;
  int64_t viewNumber;
} ChainedBftPhaseMessage__storage_;

// This method is threadsafe because it is initially called
// in +initialize for each subclass.
+ (GPBDescriptor *)descriptor {
  static GPBDescriptor *descriptor = nil;
  if (!descriptor) {
    static GPBMessageFieldDescription fields[] = {
      {
        .name = "type",
        .dataTypeSpecific.enumDescFunc = QCState_EnumDescriptor,
        .number = ChainedBftPhaseMessage_FieldNumber_Type,
        .hasIndex = 0,
        .offset = (uint32_t)offsetof(ChainedBftPhaseMessage__storage_, type),
        .flags = (GPBFieldFlags)(GPBFieldOptional | GPBFieldTextFormatNameCustom | GPBFieldHasEnumDescriptor),
        .dataType = GPBDataTypeEnum,
      },
      {
        .name = "viewNumber",
        .dataTypeSpecific.className = NULL,
        .number = ChainedBftPhaseMessage_FieldNumber_ViewNumber,
        .hasIndex = 1,
        .offset = (uint32_t)offsetof(ChainedBftPhaseMessage__storage_, viewNumber),
        .flags = (GPBFieldFlags)(GPBFieldOptional | GPBFieldTextFormatNameCustom),
        .dataType = GPBDataTypeInt64,
      },
      {
        .name = "proposalQc",
        .dataTypeSpecific.className = GPBStringifySymbol(QuorumCert),
        .number = ChainedBftPhaseMessage_FieldNumber_ProposalQc,
        .hasIndex = 2,
        .offset = (uint32_t)offsetof(ChainedBftPhaseMessage__storage_, proposalQc),
        .flags = (GPBFieldFlags)(GPBFieldOptional | GPBFieldTextFormatNameCustom),
        .dataType = GPBDataTypeMessage,
      },
      {
        .name = "justifyQc",
        .dataTypeSpecific.className = GPBStringifySymbol(QuorumCert),
        .number = ChainedBftPhaseMessage_FieldNumber_JustifyQc,
        .hasIndex = 3,
        .offset = (uint32_t)offsetof(ChainedBftPhaseMessage__storage_, justifyQc),
        .flags = (GPBFieldFlags)(GPBFieldOptional | GPBFieldTextFormatNameCustom),
        .dataType = GPBDataTypeMessage,
      },
      {
        .name = "msgDigest",
        .dataTypeSpecific.className = NULL,
        .number = ChainedBftPhaseMessage_FieldNumber_MsgDigest,
        .hasIndex = 4,
        .offset = (uint32_t)offsetof(ChainedBftPhaseMessage__storage_, msgDigest),
        .flags = (GPBFieldFlags)(GPBFieldOptional | GPBFieldTextFormatNameCustom),
        .dataType = GPBDataTypeBytes,
      },
      {
        .name = "signature",
        .dataTypeSpecific.className = GPBStringifySymbol(SignInfo),
        .number = ChainedBftPhaseMessage_FieldNumber_Signature,
        .hasIndex = 5,
        .offset = (uint32_t)offsetof(ChainedBftPhaseMessage__storage_, signature),
        .flags = (GPBFieldFlags)(GPBFieldOptional | GPBFieldTextFormatNameCustom),
        .dataType = GPBDataTypeMessage,
      },
    };
    GPBDescriptor *localDescriptor =
        [GPBDescriptor allocDescriptorForClass:[ChainedBftPhaseMessage class]
                                     rootClass:[ChainedbftRoot class]
                                          file:ChainedbftRoot_FileDescriptor()
                                        fields:fields
                                    fieldCount:(uint32_t)(sizeof(fields) / sizeof(GPBMessageFieldDescription))
                                   storageSize:sizeof(ChainedBftPhaseMessage__storage_)
                                         flags:GPBDescriptorInitializationFlag_None];
#if !GPBOBJC_SKIP_MESSAGE_TEXTFORMAT_EXTRAS
    static const char *extraTextFormatInfo =
        "\006\001D\000\002J\000\003IA\000\004HA\000\005I\000\006I\000";
    [localDescriptor setupExtraTextInfo:extraTextFormatInfo];
#endif  // !GPBOBJC_SKIP_MESSAGE_TEXTFORMAT_EXTRAS
    #if defined(DEBUG) && DEBUG
      NSAssert(descriptor == nil, @"Startup recursed!");
    #endif  // DEBUG
    descriptor = localDescriptor;
  }
  return descriptor;
}

@end

int32_t ChainedBftPhaseMessage_Type_RawValue(ChainedBftPhaseMessage *message) {
  GPBDescriptor *descriptor = [ChainedBftPhaseMessage descriptor];
  GPBFieldDescriptor *field = [descriptor fieldWithNumber:ChainedBftPhaseMessage_FieldNumber_Type];
  return GPBGetMessageInt32Field(message, field);
}

void SetChainedBftPhaseMessage_Type_RawValue(ChainedBftPhaseMessage *message, int32_t value) {
  GPBDescriptor *descriptor = [ChainedBftPhaseMessage descriptor];
  GPBFieldDescriptor *field = [descriptor fieldWithNumber:ChainedBftPhaseMessage_FieldNumber_Type];
  GPBSetInt32IvarWithFieldInternal(message, field, value, descriptor.file.syntax);
}

#pragma mark - ChainedBftVoteMessage

@implementation ChainedBftVoteMessage

@dynamic proposalId;
@dynamic hasSignature, signature;

typedef struct ChainedBftVoteMessage__storage_ {
  uint32_t _has_storage_[1];
  NSData *proposalId;
  SignInfo *signature;
} ChainedBftVoteMessage__storage_;

// This method is threadsafe because it is initially called
// in +initialize for each subclass.
+ (GPBDescriptor *)descriptor {
  static GPBDescriptor *descriptor = nil;
  if (!descriptor) {
    static GPBMessageFieldDescription fields[] = {
      {
        .name = "proposalId",
        .dataTypeSpecific.className = NULL,
        .number = ChainedBftVoteMessage_FieldNumber_ProposalId,
        .hasIndex = 0,
        .offset = (uint32_t)offsetof(ChainedBftVoteMessage__storage_, proposalId),
        .flags = (GPBFieldFlags)(GPBFieldOptional | GPBFieldTextFormatNameCustom),
        .dataType = GPBDataTypeBytes,
      },
      {
        .name = "signature",
        .dataTypeSpecific.className = GPBStringifySymbol(SignInfo),
        .number = ChainedBftVoteMessage_FieldNumber_Signature,
        .hasIndex = 1,
        .offset = (uint32_t)offsetof(ChainedBftVoteMessage__storage_, signature),
        .flags = (GPBFieldFlags)(GPBFieldOptional | GPBFieldTextFormatNameCustom),
        .dataType = GPBDataTypeMessage,
      },
    };
    GPBDescriptor *localDescriptor =
        [GPBDescriptor allocDescriptorForClass:[ChainedBftVoteMessage class]
                                     rootClass:[ChainedbftRoot class]
                                          file:ChainedbftRoot_FileDescriptor()
                                        fields:fields
                                    fieldCount:(uint32_t)(sizeof(fields) / sizeof(GPBMessageFieldDescription))
                                   storageSize:sizeof(ChainedBftVoteMessage__storage_)
                                         flags:GPBDescriptorInitializationFlag_None];
#if !GPBOBJC_SKIP_MESSAGE_TEXTFORMAT_EXTRAS
    static const char *extraTextFormatInfo =
        "\002\001J\000\002I\000";
    [localDescriptor setupExtraTextInfo:extraTextFormatInfo];
#endif  // !GPBOBJC_SKIP_MESSAGE_TEXTFORMAT_EXTRAS
    #if defined(DEBUG) && DEBUG
      NSAssert(descriptor == nil, @"Startup recursed!");
    #endif  // DEBUG
    descriptor = localDescriptor;
  }
  return descriptor;
}

@end


#pragma clang diagnostic pop

// @@protoc_insertion_point(global_scope)
