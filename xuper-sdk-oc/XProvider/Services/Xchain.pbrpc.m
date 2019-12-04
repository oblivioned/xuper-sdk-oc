#if !defined(GPB_GRPC_PROTOCOL_ONLY) || !GPB_GRPC_PROTOCOL_ONLY
#import "Xchain.pbrpc.h"
#import "Xchain.pbobjc.h"
#import <ProtoRPC/ProtoRPCLegacy.h>
#import <RxLibrary/GRXWriter+Immediate.h>

#import "Chainedbft.pbobjc.h"

@implementation Xchain

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-designated-initializers"

// Designated initializer
- (instancetype)initWithHost:(NSString *)host callOptions:(GRPCCallOptions *_Nullable)callOptions {
  return [super initWithHost:host
                 packageName:@"pb"
                 serviceName:@"Xchain"
                 callOptions:callOptions];
}

- (instancetype)initWithHost:(NSString *)host {
  return [super initWithHost:host
                 packageName:@"pb"
                 serviceName:@"Xchain"];
}

#pragma clang diagnostic pop

// Override superclass initializer to disallow different package and service names.
- (instancetype)initWithHost:(NSString *)host
                 packageName:(NSString *)packageName
                 serviceName:(NSString *)serviceName {
  return [self initWithHost:host];
}

- (instancetype)initWithHost:(NSString *)host
                 packageName:(NSString *)packageName
                 serviceName:(NSString *)serviceName
                 callOptions:(GRPCCallOptions *)callOptions {
  return [self initWithHost:host callOptions:callOptions];
}

#pragma mark - Class Methods

+ (instancetype)serviceWithHost:(NSString *)host {
  return [[self alloc] initWithHost:host];
}

+ (instancetype)serviceWithHost:(NSString *)host callOptions:(GRPCCallOptions *_Nullable)callOptions {
  return [[self alloc] initWithHost:host callOptions:callOptions];
}

#pragma mark - Method Implementations

#pragma mark PostTx(TxStatus) returns (CommonReply)

/**
 * PostTx post Transaction to a node
 *
 * This method belongs to a set of APIs that have been deprecated. Using the v2 API is recommended.
 */
- (void)postTxWithRequest:(TxStatus *)request handler:(void(^)(CommonReply *_Nullable response, NSError *_Nullable error))handler{
  [[self RPCToPostTxWithRequest:request handler:handler] start];
}
// Returns a not-yet-started RPC object.
/**
 * PostTx post Transaction to a node
 *
 * This method belongs to a set of APIs that have been deprecated. Using the v2 API is recommended.
 */
- (GRPCProtoCall *)RPCToPostTxWithRequest:(TxStatus *)request handler:(void(^)(CommonReply *_Nullable response, NSError *_Nullable error))handler{
  return [self RPCToMethod:@"PostTx"
            requestsWriter:[GRXWriter writerWithValue:request]
             responseClass:[CommonReply class]
        responsesWriteable:[GRXWriteable writeableWithSingleHandler:handler]];
}
/**
 * PostTx post Transaction to a node
 */
- (GRPCUnaryProtoCall *)postTxWithMessage:(TxStatus *)message responseHandler:(id<GRPCProtoResponseHandler>)handler callOptions:(GRPCCallOptions *_Nullable)callOptions {
  return [self RPCToMethod:@"PostTx"
                   message:message
           responseHandler:handler
               callOptions:callOptions
             responseClass:[CommonReply class]];
}

#pragma mark QueryACL(AclStatus) returns (AclStatus)

- (void)queryACLWithRequest:(AclStatus *)request handler:(void(^)(AclStatus *_Nullable response, NSError *_Nullable error))handler{
  [[self RPCToQueryACLWithRequest:request handler:handler] start];
}
// Returns a not-yet-started RPC object.
- (GRPCProtoCall *)RPCToQueryACLWithRequest:(AclStatus *)request handler:(void(^)(AclStatus *_Nullable response, NSError *_Nullable error))handler{
  return [self RPCToMethod:@"QueryACL"
            requestsWriter:[GRXWriter writerWithValue:request]
             responseClass:[AclStatus class]
        responsesWriteable:[GRXWriteable writeableWithSingleHandler:handler]];
}
- (GRPCUnaryProtoCall *)queryACLWithMessage:(AclStatus *)message responseHandler:(id<GRPCProtoResponseHandler>)handler callOptions:(GRPCCallOptions *_Nullable)callOptions {
  return [self RPCToMethod:@"QueryACL"
                   message:message
           responseHandler:handler
               callOptions:callOptions
             responseClass:[AclStatus class]];
}

#pragma mark GetAccountContracts(GetAccountContractsRequest) returns (GetAccountContractsResponse)

- (void)getAccountContractsWithRequest:(GetAccountContractsRequest *)request handler:(void(^)(GetAccountContractsResponse *_Nullable response, NSError *_Nullable error))handler{
  [[self RPCToGetAccountContractsWithRequest:request handler:handler] start];
}
// Returns a not-yet-started RPC object.
- (GRPCProtoCall *)RPCToGetAccountContractsWithRequest:(GetAccountContractsRequest *)request handler:(void(^)(GetAccountContractsResponse *_Nullable response, NSError *_Nullable error))handler{
  return [self RPCToMethod:@"GetAccountContracts"
            requestsWriter:[GRXWriter writerWithValue:request]
             responseClass:[GetAccountContractsResponse class]
        responsesWriteable:[GRXWriteable writeableWithSingleHandler:handler]];
}
- (GRPCUnaryProtoCall *)getAccountContractsWithMessage:(GetAccountContractsRequest *)message responseHandler:(id<GRPCProtoResponseHandler>)handler callOptions:(GRPCCallOptions *_Nullable)callOptions {
  return [self RPCToMethod:@"GetAccountContracts"
                   message:message
           responseHandler:handler
               callOptions:callOptions
             responseClass:[GetAccountContractsResponse class]];
}

#pragma mark QueryTx(TxStatus) returns (TxStatus)

/**
 * QueryTx query Transaction by TxStatus,
 * Bcname and Txid are required for this
 *
 * This method belongs to a set of APIs that have been deprecated. Using the v2 API is recommended.
 */
- (void)queryTxWithRequest:(TxStatus *)request handler:(void(^)(TxStatus *_Nullable response, NSError *_Nullable error))handler{
  [[self RPCToQueryTxWithRequest:request handler:handler] start];
}
// Returns a not-yet-started RPC object.
/**
 * QueryTx query Transaction by TxStatus,
 * Bcname and Txid are required for this
 *
 * This method belongs to a set of APIs that have been deprecated. Using the v2 API is recommended.
 */
- (GRPCProtoCall *)RPCToQueryTxWithRequest:(TxStatus *)request handler:(void(^)(TxStatus *_Nullable response, NSError *_Nullable error))handler{
  return [self RPCToMethod:@"QueryTx"
            requestsWriter:[GRXWriter writerWithValue:request]
             responseClass:[TxStatus class]
        responsesWriteable:[GRXWriteable writeableWithSingleHandler:handler]];
}
/**
 * QueryTx query Transaction by TxStatus,
 * Bcname and Txid are required for this
 */
- (GRPCUnaryProtoCall *)queryTxWithMessage:(TxStatus *)message responseHandler:(id<GRPCProtoResponseHandler>)handler callOptions:(GRPCCallOptions *_Nullable)callOptions {
  return [self RPCToMethod:@"QueryTx"
                   message:message
           responseHandler:handler
               callOptions:callOptions
             responseClass:[TxStatus class]];
}

#pragma mark GetBalance(AddressStatus) returns (AddressStatus)

/**
 * GetBalance get balance of an address,
 * Address is required for this
 *
 * This method belongs to a set of APIs that have been deprecated. Using the v2 API is recommended.
 */
- (void)getBalanceWithRequest:(AddressStatus *)request handler:(void(^)(AddressStatus *_Nullable response, NSError *_Nullable error))handler{
  [[self RPCToGetBalanceWithRequest:request handler:handler] start];
}
// Returns a not-yet-started RPC object.
/**
 * GetBalance get balance of an address,
 * Address is required for this
 *
 * This method belongs to a set of APIs that have been deprecated. Using the v2 API is recommended.
 */
- (GRPCProtoCall *)RPCToGetBalanceWithRequest:(AddressStatus *)request handler:(void(^)(AddressStatus *_Nullable response, NSError *_Nullable error))handler{
  return [self RPCToMethod:@"GetBalance"
            requestsWriter:[GRXWriter writerWithValue:request]
             responseClass:[AddressStatus class]
        responsesWriteable:[GRXWriteable writeableWithSingleHandler:handler]];
}
/**
 * GetBalance get balance of an address,
 * Address is required for this
 */
- (GRPCUnaryProtoCall *)getBalanceWithMessage:(AddressStatus *)message responseHandler:(id<GRPCProtoResponseHandler>)handler callOptions:(GRPCCallOptions *_Nullable)callOptions {
  return [self RPCToMethod:@"GetBalance"
                   message:message
           responseHandler:handler
               callOptions:callOptions
             responseClass:[AddressStatus class]];
}

#pragma mark GetBalanceDetail(AddressBalanceStatus) returns (AddressBalanceStatus)

/**
 * GetFrozenBalance get two kinds of balance
 * 1. Still be frozen of an address
 * 2. Available now of an address
 * Address is required for this
 *
 * This method belongs to a set of APIs that have been deprecated. Using the v2 API is recommended.
 */
- (void)getBalanceDetailWithRequest:(AddressBalanceStatus *)request handler:(void(^)(AddressBalanceStatus *_Nullable response, NSError *_Nullable error))handler{
  [[self RPCToGetBalanceDetailWithRequest:request handler:handler] start];
}
// Returns a not-yet-started RPC object.
/**
 * GetFrozenBalance get two kinds of balance
 * 1. Still be frozen of an address
 * 2. Available now of an address
 * Address is required for this
 *
 * This method belongs to a set of APIs that have been deprecated. Using the v2 API is recommended.
 */
- (GRPCProtoCall *)RPCToGetBalanceDetailWithRequest:(AddressBalanceStatus *)request handler:(void(^)(AddressBalanceStatus *_Nullable response, NSError *_Nullable error))handler{
  return [self RPCToMethod:@"GetBalanceDetail"
            requestsWriter:[GRXWriter writerWithValue:request]
             responseClass:[AddressBalanceStatus class]
        responsesWriteable:[GRXWriteable writeableWithSingleHandler:handler]];
}
/**
 * GetFrozenBalance get two kinds of balance
 * 1. Still be frozen of an address
 * 2. Available now of an address
 * Address is required for this
 */
- (GRPCUnaryProtoCall *)getBalanceDetailWithMessage:(AddressBalanceStatus *)message responseHandler:(id<GRPCProtoResponseHandler>)handler callOptions:(GRPCCallOptions *_Nullable)callOptions {
  return [self RPCToMethod:@"GetBalanceDetail"
                   message:message
           responseHandler:handler
               callOptions:callOptions
             responseClass:[AddressBalanceStatus class]];
}

#pragma mark GetFrozenBalance(AddressStatus) returns (AddressStatus)

/**
 * GetFrozenBalance get balance that still be frozen of an address,
 * Address is required for this
 *
 * This method belongs to a set of APIs that have been deprecated. Using the v2 API is recommended.
 */
- (void)getFrozenBalanceWithRequest:(AddressStatus *)request handler:(void(^)(AddressStatus *_Nullable response, NSError *_Nullable error))handler{
  [[self RPCToGetFrozenBalanceWithRequest:request handler:handler] start];
}
// Returns a not-yet-started RPC object.
/**
 * GetFrozenBalance get balance that still be frozen of an address,
 * Address is required for this
 *
 * This method belongs to a set of APIs that have been deprecated. Using the v2 API is recommended.
 */
- (GRPCProtoCall *)RPCToGetFrozenBalanceWithRequest:(AddressStatus *)request handler:(void(^)(AddressStatus *_Nullable response, NSError *_Nullable error))handler{
  return [self RPCToMethod:@"GetFrozenBalance"
            requestsWriter:[GRXWriter writerWithValue:request]
             responseClass:[AddressStatus class]
        responsesWriteable:[GRXWriteable writeableWithSingleHandler:handler]];
}
/**
 * GetFrozenBalance get balance that still be frozen of an address,
 * Address is required for this
 */
- (GRPCUnaryProtoCall *)getFrozenBalanceWithMessage:(AddressStatus *)message responseHandler:(id<GRPCProtoResponseHandler>)handler callOptions:(GRPCCallOptions *_Nullable)callOptions {
  return [self RPCToMethod:@"GetFrozenBalance"
                   message:message
           responseHandler:handler
               callOptions:callOptions
             responseClass:[AddressStatus class]];
}

#pragma mark GetBlock(BlockID) returns (Block)

/**
 * GetBlock get block by blockid and return if the block in trunk or in branch
 *
 * This method belongs to a set of APIs that have been deprecated. Using the v2 API is recommended.
 */
- (void)getBlockWithRequest:(BlockID *)request handler:(void(^)(Block *_Nullable response, NSError *_Nullable error))handler{
  [[self RPCToGetBlockWithRequest:request handler:handler] start];
}
// Returns a not-yet-started RPC object.
/**
 * GetBlock get block by blockid and return if the block in trunk or in branch
 *
 * This method belongs to a set of APIs that have been deprecated. Using the v2 API is recommended.
 */
- (GRPCProtoCall *)RPCToGetBlockWithRequest:(BlockID *)request handler:(void(^)(Block *_Nullable response, NSError *_Nullable error))handler{
  return [self RPCToMethod:@"GetBlock"
            requestsWriter:[GRXWriter writerWithValue:request]
             responseClass:[Block class]
        responsesWriteable:[GRXWriteable writeableWithSingleHandler:handler]];
}
/**
 * GetBlock get block by blockid and return if the block in trunk or in branch
 */
- (GRPCUnaryProtoCall *)getBlockWithMessage:(BlockID *)message responseHandler:(id<GRPCProtoResponseHandler>)handler callOptions:(GRPCCallOptions *_Nullable)callOptions {
  return [self RPCToMethod:@"GetBlock"
                   message:message
           responseHandler:handler
               callOptions:callOptions
             responseClass:[Block class]];
}

#pragma mark GetBlockByHeight(BlockHeight) returns (Block)

/**
 * GetBlockByHeight get block by height and return if the block in trunk or in
 * branch
 *
 * This method belongs to a set of APIs that have been deprecated. Using the v2 API is recommended.
 */
- (void)getBlockByHeightWithRequest:(BlockHeight *)request handler:(void(^)(Block *_Nullable response, NSError *_Nullable error))handler{
  [[self RPCToGetBlockByHeightWithRequest:request handler:handler] start];
}
// Returns a not-yet-started RPC object.
/**
 * GetBlockByHeight get block by height and return if the block in trunk or in
 * branch
 *
 * This method belongs to a set of APIs that have been deprecated. Using the v2 API is recommended.
 */
- (GRPCProtoCall *)RPCToGetBlockByHeightWithRequest:(BlockHeight *)request handler:(void(^)(Block *_Nullable response, NSError *_Nullable error))handler{
  return [self RPCToMethod:@"GetBlockByHeight"
            requestsWriter:[GRXWriter writerWithValue:request]
             responseClass:[Block class]
        responsesWriteable:[GRXWriteable writeableWithSingleHandler:handler]];
}
/**
 * GetBlockByHeight get block by height and return if the block in trunk or in
 * branch
 */
- (GRPCUnaryProtoCall *)getBlockByHeightWithMessage:(BlockHeight *)message responseHandler:(id<GRPCProtoResponseHandler>)handler callOptions:(GRPCCallOptions *_Nullable)callOptions {
  return [self RPCToMethod:@"GetBlockByHeight"
                   message:message
           responseHandler:handler
               callOptions:callOptions
             responseClass:[Block class]];
}

#pragma mark GetBlockChainStatus(BCStatus) returns (BCStatus)

- (void)getBlockChainStatusWithRequest:(BCStatus *)request handler:(void(^)(BCStatus *_Nullable response, NSError *_Nullable error))handler{
  [[self RPCToGetBlockChainStatusWithRequest:request handler:handler] start];
}
// Returns a not-yet-started RPC object.
- (GRPCProtoCall *)RPCToGetBlockChainStatusWithRequest:(BCStatus *)request handler:(void(^)(BCStatus *_Nullable response, NSError *_Nullable error))handler{
  return [self RPCToMethod:@"GetBlockChainStatus"
            requestsWriter:[GRXWriter writerWithValue:request]
             responseClass:[BCStatus class]
        responsesWriteable:[GRXWriteable writeableWithSingleHandler:handler]];
}
- (GRPCUnaryProtoCall *)getBlockChainStatusWithMessage:(BCStatus *)message responseHandler:(id<GRPCProtoResponseHandler>)handler callOptions:(GRPCCallOptions *_Nullable)callOptions {
  return [self RPCToMethod:@"GetBlockChainStatus"
                   message:message
           responseHandler:handler
               callOptions:callOptions
             responseClass:[BCStatus class]];
}

#pragma mark GetBlockChains(CommonIn) returns (BlockChains)

/**
 * Get blockchains query blockchains
 *
 * This method belongs to a set of APIs that have been deprecated. Using the v2 API is recommended.
 */
- (void)getBlockChainsWithRequest:(CommonIn *)request handler:(void(^)(BlockChains *_Nullable response, NSError *_Nullable error))handler{
  [[self RPCToGetBlockChainsWithRequest:request handler:handler] start];
}
// Returns a not-yet-started RPC object.
/**
 * Get blockchains query blockchains
 *
 * This method belongs to a set of APIs that have been deprecated. Using the v2 API is recommended.
 */
- (GRPCProtoCall *)RPCToGetBlockChainsWithRequest:(CommonIn *)request handler:(void(^)(BlockChains *_Nullable response, NSError *_Nullable error))handler{
  return [self RPCToMethod:@"GetBlockChains"
            requestsWriter:[GRXWriter writerWithValue:request]
             responseClass:[BlockChains class]
        responsesWriteable:[GRXWriteable writeableWithSingleHandler:handler]];
}
/**
 * Get blockchains query blockchains
 */
- (GRPCUnaryProtoCall *)getBlockChainsWithMessage:(CommonIn *)message responseHandler:(id<GRPCProtoResponseHandler>)handler callOptions:(GRPCCallOptions *_Nullable)callOptions {
  return [self RPCToMethod:@"GetBlockChains"
                   message:message
           responseHandler:handler
               callOptions:callOptions
             responseClass:[BlockChains class]];
}

#pragma mark GetSystemStatus(CommonIn) returns (SystemsStatusReply)

/**
 * GetSystemStatus query system status
 *
 * This method belongs to a set of APIs that have been deprecated. Using the v2 API is recommended.
 */
- (void)getSystemStatusWithRequest:(CommonIn *)request handler:(void(^)(SystemsStatusReply *_Nullable response, NSError *_Nullable error))handler{
  [[self RPCToGetSystemStatusWithRequest:request handler:handler] start];
}
// Returns a not-yet-started RPC object.
/**
 * GetSystemStatus query system status
 *
 * This method belongs to a set of APIs that have been deprecated. Using the v2 API is recommended.
 */
- (GRPCProtoCall *)RPCToGetSystemStatusWithRequest:(CommonIn *)request handler:(void(^)(SystemsStatusReply *_Nullable response, NSError *_Nullable error))handler{
  return [self RPCToMethod:@"GetSystemStatus"
            requestsWriter:[GRXWriter writerWithValue:request]
             responseClass:[SystemsStatusReply class]
        responsesWriteable:[GRXWriteable writeableWithSingleHandler:handler]];
}
/**
 * GetSystemStatus query system status
 */
- (GRPCUnaryProtoCall *)getSystemStatusWithMessage:(CommonIn *)message responseHandler:(id<GRPCProtoResponseHandler>)handler callOptions:(GRPCCallOptions *_Nullable)callOptions {
  return [self RPCToMethod:@"GetSystemStatus"
                   message:message
           responseHandler:handler
               callOptions:callOptions
             responseClass:[SystemsStatusReply class]];
}

#pragma mark GetNetURL(CommonIn) returns (RawUrl)

/**
 * GetNetURL return net url
 *
 * This method belongs to a set of APIs that have been deprecated. Using the v2 API is recommended.
 */
- (void)getNetURLWithRequest:(CommonIn *)request handler:(void(^)(RawUrl *_Nullable response, NSError *_Nullable error))handler{
  [[self RPCToGetNetURLWithRequest:request handler:handler] start];
}
// Returns a not-yet-started RPC object.
/**
 * GetNetURL return net url
 *
 * This method belongs to a set of APIs that have been deprecated. Using the v2 API is recommended.
 */
- (GRPCProtoCall *)RPCToGetNetURLWithRequest:(CommonIn *)request handler:(void(^)(RawUrl *_Nullable response, NSError *_Nullable error))handler{
  return [self RPCToMethod:@"GetNetURL"
            requestsWriter:[GRXWriter writerWithValue:request]
             responseClass:[RawUrl class]
        responsesWriteable:[GRXWriteable writeableWithSingleHandler:handler]];
}
/**
 * GetNetURL return net url
 */
- (GRPCUnaryProtoCall *)getNetURLWithMessage:(CommonIn *)message responseHandler:(id<GRPCProtoResponseHandler>)handler callOptions:(GRPCCallOptions *_Nullable)callOptions {
  return [self RPCToMethod:@"GetNetURL"
                   message:message
           responseHandler:handler
               callOptions:callOptions
             responseClass:[RawUrl class]];
}

#pragma mark SelectUTXO(UtxoInput) returns (UtxoOutput)

/**
 * 新的Select utxos接口, 不需要签名，可以支持选择账户的utxo
 *
 * This method belongs to a set of APIs that have been deprecated. Using the v2 API is recommended.
 */
- (void)selectUTXOWithRequest:(UtxoInput *)request handler:(void(^)(UtxoOutput *_Nullable response, NSError *_Nullable error))handler{
  [[self RPCToSelectUTXOWithRequest:request handler:handler] start];
}
// Returns a not-yet-started RPC object.
/**
 * 新的Select utxos接口, 不需要签名，可以支持选择账户的utxo
 *
 * This method belongs to a set of APIs that have been deprecated. Using the v2 API is recommended.
 */
- (GRPCProtoCall *)RPCToSelectUTXOWithRequest:(UtxoInput *)request handler:(void(^)(UtxoOutput *_Nullable response, NSError *_Nullable error))handler{
  return [self RPCToMethod:@"SelectUTXO"
            requestsWriter:[GRXWriter writerWithValue:request]
             responseClass:[UtxoOutput class]
        responsesWriteable:[GRXWriteable writeableWithSingleHandler:handler]];
}
/**
 * 新的Select utxos接口, 不需要签名，可以支持选择账户的utxo
 */
- (GRPCUnaryProtoCall *)selectUTXOWithMessage:(UtxoInput *)message responseHandler:(id<GRPCProtoResponseHandler>)handler callOptions:(GRPCCallOptions *_Nullable)callOptions {
  return [self RPCToMethod:@"SelectUTXO"
                   message:message
           responseHandler:handler
               callOptions:callOptions
             responseClass:[UtxoOutput class]];
}

#pragma mark PreExecWithSelectUTXO(PreExecWithSelectUTXORequest) returns (PreExecWithSelectUTXOResponse)

/**
 * PreExecWithSelectUTXO preExec & selectUtxo
 *
 * This method belongs to a set of APIs that have been deprecated. Using the v2 API is recommended.
 */
- (void)preExecWithSelectUTXOWithRequest:(PreExecWithSelectUTXORequest *)request handler:(void(^)(PreExecWithSelectUTXOResponse *_Nullable response, NSError *_Nullable error))handler{
  [[self RPCToPreExecWithSelectUTXOWithRequest:request handler:handler] start];
}
// Returns a not-yet-started RPC object.
/**
 * PreExecWithSelectUTXO preExec & selectUtxo
 *
 * This method belongs to a set of APIs that have been deprecated. Using the v2 API is recommended.
 */
- (GRPCProtoCall *)RPCToPreExecWithSelectUTXOWithRequest:(PreExecWithSelectUTXORequest *)request handler:(void(^)(PreExecWithSelectUTXOResponse *_Nullable response, NSError *_Nullable error))handler{
  return [self RPCToMethod:@"PreExecWithSelectUTXO"
            requestsWriter:[GRXWriter writerWithValue:request]
             responseClass:[PreExecWithSelectUTXOResponse class]
        responsesWriteable:[GRXWriteable writeableWithSingleHandler:handler]];
}
/**
 * PreExecWithSelectUTXO preExec & selectUtxo
 */
- (GRPCUnaryProtoCall *)preExecWithSelectUTXOWithMessage:(PreExecWithSelectUTXORequest *)message responseHandler:(id<GRPCProtoResponseHandler>)handler callOptions:(GRPCCallOptions *_Nullable)callOptions {
  return [self RPCToMethod:@"PreExecWithSelectUTXO"
                   message:message
           responseHandler:handler
               callOptions:callOptions
             responseClass:[PreExecWithSelectUTXOResponse class]];
}

#pragma mark DeployNativeCode(DeployNativeCodeRequest) returns (DeployNativeCodeResponse)

/**
 * Native code deploy interface
 *
 * This method belongs to a set of APIs that have been deprecated. Using the v2 API is recommended.
 */
- (void)deployNativeCodeWithRequest:(DeployNativeCodeRequest *)request handler:(void(^)(DeployNativeCodeResponse *_Nullable response, NSError *_Nullable error))handler{
  [[self RPCToDeployNativeCodeWithRequest:request handler:handler] start];
}
// Returns a not-yet-started RPC object.
/**
 * Native code deploy interface
 *
 * This method belongs to a set of APIs that have been deprecated. Using the v2 API is recommended.
 */
- (GRPCProtoCall *)RPCToDeployNativeCodeWithRequest:(DeployNativeCodeRequest *)request handler:(void(^)(DeployNativeCodeResponse *_Nullable response, NSError *_Nullable error))handler{
  return [self RPCToMethod:@"DeployNativeCode"
            requestsWriter:[GRXWriter writerWithValue:request]
             responseClass:[DeployNativeCodeResponse class]
        responsesWriteable:[GRXWriteable writeableWithSingleHandler:handler]];
}
/**
 * Native code deploy interface
 */
- (GRPCUnaryProtoCall *)deployNativeCodeWithMessage:(DeployNativeCodeRequest *)message responseHandler:(id<GRPCProtoResponseHandler>)handler callOptions:(GRPCCallOptions *_Nullable)callOptions {
  return [self RPCToMethod:@"DeployNativeCode"
                   message:message
           responseHandler:handler
               callOptions:callOptions
             responseClass:[DeployNativeCodeResponse class]];
}

#pragma mark NativeCodeStatus(NativeCodeStatusRequest) returns (NativeCodeStatusResponse)

/**
 * Native code status
 *
 * This method belongs to a set of APIs that have been deprecated. Using the v2 API is recommended.
 */
- (void)nativeCodeStatusWithRequest:(NativeCodeStatusRequest *)request handler:(void(^)(NativeCodeStatusResponse *_Nullable response, NSError *_Nullable error))handler{
  [[self RPCToNativeCodeStatusWithRequest:request handler:handler] start];
}
// Returns a not-yet-started RPC object.
/**
 * Native code status
 *
 * This method belongs to a set of APIs that have been deprecated. Using the v2 API is recommended.
 */
- (GRPCProtoCall *)RPCToNativeCodeStatusWithRequest:(NativeCodeStatusRequest *)request handler:(void(^)(NativeCodeStatusResponse *_Nullable response, NSError *_Nullable error))handler{
  return [self RPCToMethod:@"NativeCodeStatus"
            requestsWriter:[GRXWriter writerWithValue:request]
             responseClass:[NativeCodeStatusResponse class]
        responsesWriteable:[GRXWriteable writeableWithSingleHandler:handler]];
}
/**
 * Native code status
 */
- (GRPCUnaryProtoCall *)nativeCodeStatusWithMessage:(NativeCodeStatusRequest *)message responseHandler:(id<GRPCProtoResponseHandler>)handler callOptions:(GRPCCallOptions *_Nullable)callOptions {
  return [self RPCToMethod:@"NativeCodeStatus"
                   message:message
           responseHandler:handler
               callOptions:callOptions
             responseClass:[NativeCodeStatusResponse class]];
}

#pragma mark DposCandidates(DposCandidatesRequest) returns (DposCandidatesResponse)

/**
 * 
 * DPoS query interface
 * 
 * DposCandidates get all candidates of the tdpos consensus
 *
 * This method belongs to a set of APIs that have been deprecated. Using the v2 API is recommended.
 */
- (void)dposCandidatesWithRequest:(DposCandidatesRequest *)request handler:(void(^)(DposCandidatesResponse *_Nullable response, NSError *_Nullable error))handler{
  [[self RPCToDposCandidatesWithRequest:request handler:handler] start];
}
// Returns a not-yet-started RPC object.
/**
 * 
 * DPoS query interface
 * 
 * DposCandidates get all candidates of the tdpos consensus
 *
 * This method belongs to a set of APIs that have been deprecated. Using the v2 API is recommended.
 */
- (GRPCProtoCall *)RPCToDposCandidatesWithRequest:(DposCandidatesRequest *)request handler:(void(^)(DposCandidatesResponse *_Nullable response, NSError *_Nullable error))handler{
  return [self RPCToMethod:@"DposCandidates"
            requestsWriter:[GRXWriter writerWithValue:request]
             responseClass:[DposCandidatesResponse class]
        responsesWriteable:[GRXWriteable writeableWithSingleHandler:handler]];
}
/**
 * 
 * DPoS query interface
 * 
 * DposCandidates get all candidates of the tdpos consensus
 */
- (GRPCUnaryProtoCall *)dposCandidatesWithMessage:(DposCandidatesRequest *)message responseHandler:(id<GRPCProtoResponseHandler>)handler callOptions:(GRPCCallOptions *_Nullable)callOptions {
  return [self RPCToMethod:@"DposCandidates"
                   message:message
           responseHandler:handler
               callOptions:callOptions
             responseClass:[DposCandidatesResponse class]];
}

#pragma mark DposNominateRecords(DposNominateRecordsRequest) returns (DposNominateRecordsResponse)

/**
 * DposNominateRecords get all records nominated by an user
 *
 * This method belongs to a set of APIs that have been deprecated. Using the v2 API is recommended.
 */
- (void)dposNominateRecordsWithRequest:(DposNominateRecordsRequest *)request handler:(void(^)(DposNominateRecordsResponse *_Nullable response, NSError *_Nullable error))handler{
  [[self RPCToDposNominateRecordsWithRequest:request handler:handler] start];
}
// Returns a not-yet-started RPC object.
/**
 * DposNominateRecords get all records nominated by an user
 *
 * This method belongs to a set of APIs that have been deprecated. Using the v2 API is recommended.
 */
- (GRPCProtoCall *)RPCToDposNominateRecordsWithRequest:(DposNominateRecordsRequest *)request handler:(void(^)(DposNominateRecordsResponse *_Nullable response, NSError *_Nullable error))handler{
  return [self RPCToMethod:@"DposNominateRecords"
            requestsWriter:[GRXWriter writerWithValue:request]
             responseClass:[DposNominateRecordsResponse class]
        responsesWriteable:[GRXWriteable writeableWithSingleHandler:handler]];
}
/**
 * DposNominateRecords get all records nominated by an user
 */
- (GRPCUnaryProtoCall *)dposNominateRecordsWithMessage:(DposNominateRecordsRequest *)message responseHandler:(id<GRPCProtoResponseHandler>)handler callOptions:(GRPCCallOptions *_Nullable)callOptions {
  return [self RPCToMethod:@"DposNominateRecords"
                   message:message
           responseHandler:handler
               callOptions:callOptions
             responseClass:[DposNominateRecordsResponse class]];
}

#pragma mark DposNomineeRecords(DposNomineeRecordsRequest) returns (DposNomineeRecordsResponse)

/**
 * DposNomineeRecords get nominated record of a candidate
 *
 * This method belongs to a set of APIs that have been deprecated. Using the v2 API is recommended.
 */
- (void)dposNomineeRecordsWithRequest:(DposNomineeRecordsRequest *)request handler:(void(^)(DposNomineeRecordsResponse *_Nullable response, NSError *_Nullable error))handler{
  [[self RPCToDposNomineeRecordsWithRequest:request handler:handler] start];
}
// Returns a not-yet-started RPC object.
/**
 * DposNomineeRecords get nominated record of a candidate
 *
 * This method belongs to a set of APIs that have been deprecated. Using the v2 API is recommended.
 */
- (GRPCProtoCall *)RPCToDposNomineeRecordsWithRequest:(DposNomineeRecordsRequest *)request handler:(void(^)(DposNomineeRecordsResponse *_Nullable response, NSError *_Nullable error))handler{
  return [self RPCToMethod:@"DposNomineeRecords"
            requestsWriter:[GRXWriter writerWithValue:request]
             responseClass:[DposNomineeRecordsResponse class]
        responsesWriteable:[GRXWriteable writeableWithSingleHandler:handler]];
}
/**
 * DposNomineeRecords get nominated record of a candidate
 */
- (GRPCUnaryProtoCall *)dposNomineeRecordsWithMessage:(DposNomineeRecordsRequest *)message responseHandler:(id<GRPCProtoResponseHandler>)handler callOptions:(GRPCCallOptions *_Nullable)callOptions {
  return [self RPCToMethod:@"DposNomineeRecords"
                   message:message
           responseHandler:handler
               callOptions:callOptions
             responseClass:[DposNomineeRecordsResponse class]];
}

#pragma mark DposVoteRecords(DposVoteRecordsRequest) returns (DposVoteRecordsResponse)

/**
 * DposVoteRecords get all vote records voted by an user
 *
 * This method belongs to a set of APIs that have been deprecated. Using the v2 API is recommended.
 */
- (void)dposVoteRecordsWithRequest:(DposVoteRecordsRequest *)request handler:(void(^)(DposVoteRecordsResponse *_Nullable response, NSError *_Nullable error))handler{
  [[self RPCToDposVoteRecordsWithRequest:request handler:handler] start];
}
// Returns a not-yet-started RPC object.
/**
 * DposVoteRecords get all vote records voted by an user
 *
 * This method belongs to a set of APIs that have been deprecated. Using the v2 API is recommended.
 */
- (GRPCProtoCall *)RPCToDposVoteRecordsWithRequest:(DposVoteRecordsRequest *)request handler:(void(^)(DposVoteRecordsResponse *_Nullable response, NSError *_Nullable error))handler{
  return [self RPCToMethod:@"DposVoteRecords"
            requestsWriter:[GRXWriter writerWithValue:request]
             responseClass:[DposVoteRecordsResponse class]
        responsesWriteable:[GRXWriteable writeableWithSingleHandler:handler]];
}
/**
 * DposVoteRecords get all vote records voted by an user
 */
- (GRPCUnaryProtoCall *)dposVoteRecordsWithMessage:(DposVoteRecordsRequest *)message responseHandler:(id<GRPCProtoResponseHandler>)handler callOptions:(GRPCCallOptions *_Nullable)callOptions {
  return [self RPCToMethod:@"DposVoteRecords"
                   message:message
           responseHandler:handler
               callOptions:callOptions
             responseClass:[DposVoteRecordsResponse class]];
}

#pragma mark DposVotedRecords(DposVotedRecordsRequest) returns (DposVotedRecordsResponse)

/**
 * DposVotedRecords get all vote records of a candidate
 *
 * This method belongs to a set of APIs that have been deprecated. Using the v2 API is recommended.
 */
- (void)dposVotedRecordsWithRequest:(DposVotedRecordsRequest *)request handler:(void(^)(DposVotedRecordsResponse *_Nullable response, NSError *_Nullable error))handler{
  [[self RPCToDposVotedRecordsWithRequest:request handler:handler] start];
}
// Returns a not-yet-started RPC object.
/**
 * DposVotedRecords get all vote records of a candidate
 *
 * This method belongs to a set of APIs that have been deprecated. Using the v2 API is recommended.
 */
- (GRPCProtoCall *)RPCToDposVotedRecordsWithRequest:(DposVotedRecordsRequest *)request handler:(void(^)(DposVotedRecordsResponse *_Nullable response, NSError *_Nullable error))handler{
  return [self RPCToMethod:@"DposVotedRecords"
            requestsWriter:[GRXWriter writerWithValue:request]
             responseClass:[DposVotedRecordsResponse class]
        responsesWriteable:[GRXWriteable writeableWithSingleHandler:handler]];
}
/**
 * DposVotedRecords get all vote records of a candidate
 */
- (GRPCUnaryProtoCall *)dposVotedRecordsWithMessage:(DposVotedRecordsRequest *)message responseHandler:(id<GRPCProtoResponseHandler>)handler callOptions:(GRPCCallOptions *_Nullable)callOptions {
  return [self RPCToMethod:@"DposVotedRecords"
                   message:message
           responseHandler:handler
               callOptions:callOptions
             responseClass:[DposVotedRecordsResponse class]];
}

#pragma mark DposCheckResults(DposCheckResultsRequest) returns (DposCheckResultsResponse)

/**
 * DposCheckResults get check results of a specific term
 *
 * This method belongs to a set of APIs that have been deprecated. Using the v2 API is recommended.
 */
- (void)dposCheckResultsWithRequest:(DposCheckResultsRequest *)request handler:(void(^)(DposCheckResultsResponse *_Nullable response, NSError *_Nullable error))handler{
  [[self RPCToDposCheckResultsWithRequest:request handler:handler] start];
}
// Returns a not-yet-started RPC object.
/**
 * DposCheckResults get check results of a specific term
 *
 * This method belongs to a set of APIs that have been deprecated. Using the v2 API is recommended.
 */
- (GRPCProtoCall *)RPCToDposCheckResultsWithRequest:(DposCheckResultsRequest *)request handler:(void(^)(DposCheckResultsResponse *_Nullable response, NSError *_Nullable error))handler{
  return [self RPCToMethod:@"DposCheckResults"
            requestsWriter:[GRXWriter writerWithValue:request]
             responseClass:[DposCheckResultsResponse class]
        responsesWriteable:[GRXWriteable writeableWithSingleHandler:handler]];
}
/**
 * DposCheckResults get check results of a specific term
 */
- (GRPCUnaryProtoCall *)dposCheckResultsWithMessage:(DposCheckResultsRequest *)message responseHandler:(id<GRPCProtoResponseHandler>)handler callOptions:(GRPCCallOptions *_Nullable)callOptions {
  return [self RPCToMethod:@"DposCheckResults"
                   message:message
           responseHandler:handler
               callOptions:callOptions
             responseClass:[DposCheckResultsResponse class]];
}

#pragma mark DposStatus(DposStatusRequest) returns (DposStatusResponse)

/**
 * DposStatus get dpos status
 *
 * This method belongs to a set of APIs that have been deprecated. Using the v2 API is recommended.
 */
- (void)dposStatusWithRequest:(DposStatusRequest *)request handler:(void(^)(DposStatusResponse *_Nullable response, NSError *_Nullable error))handler{
  [[self RPCToDposStatusWithRequest:request handler:handler] start];
}
// Returns a not-yet-started RPC object.
/**
 * DposStatus get dpos status
 *
 * This method belongs to a set of APIs that have been deprecated. Using the v2 API is recommended.
 */
- (GRPCProtoCall *)RPCToDposStatusWithRequest:(DposStatusRequest *)request handler:(void(^)(DposStatusResponse *_Nullable response, NSError *_Nullable error))handler{
  return [self RPCToMethod:@"DposStatus"
            requestsWriter:[GRXWriter writerWithValue:request]
             responseClass:[DposStatusResponse class]
        responsesWriteable:[GRXWriteable writeableWithSingleHandler:handler]];
}
/**
 * DposStatus get dpos status
 */
- (GRPCUnaryProtoCall *)dposStatusWithMessage:(DposStatusRequest *)message responseHandler:(id<GRPCProtoResponseHandler>)handler callOptions:(GRPCCallOptions *_Nullable)callOptions {
  return [self RPCToMethod:@"DposStatus"
                   message:message
           responseHandler:handler
               callOptions:callOptions
             responseClass:[DposStatusResponse class]];
}

#pragma mark GetAccountByAK(AK2AccountRequest) returns (AK2AccountResponse)

/**
 * GetAccountByAK get account sets contain a specific address
 *
 * This method belongs to a set of APIs that have been deprecated. Using the v2 API is recommended.
 */
- (void)getAccountByAKWithRequest:(AK2AccountRequest *)request handler:(void(^)(AK2AccountResponse *_Nullable response, NSError *_Nullable error))handler{
  [[self RPCToGetAccountByAKWithRequest:request handler:handler] start];
}
// Returns a not-yet-started RPC object.
/**
 * GetAccountByAK get account sets contain a specific address
 *
 * This method belongs to a set of APIs that have been deprecated. Using the v2 API is recommended.
 */
- (GRPCProtoCall *)RPCToGetAccountByAKWithRequest:(AK2AccountRequest *)request handler:(void(^)(AK2AccountResponse *_Nullable response, NSError *_Nullable error))handler{
  return [self RPCToMethod:@"GetAccountByAK"
            requestsWriter:[GRXWriter writerWithValue:request]
             responseClass:[AK2AccountResponse class]
        responsesWriteable:[GRXWriteable writeableWithSingleHandler:handler]];
}
/**
 * GetAccountByAK get account sets contain a specific address
 */
- (GRPCUnaryProtoCall *)getAccountByAKWithMessage:(AK2AccountRequest *)message responseHandler:(id<GRPCProtoResponseHandler>)handler callOptions:(GRPCCallOptions *_Nullable)callOptions {
  return [self RPCToMethod:@"GetAccountByAK"
                   message:message
           responseHandler:handler
               callOptions:callOptions
             responseClass:[AK2AccountResponse class]];
}

#pragma mark PreExec(InvokeRPCRequest) returns (InvokeRPCResponse)

/**
 * 预执行合约
 *
 * This method belongs to a set of APIs that have been deprecated. Using the v2 API is recommended.
 */
- (void)preExecWithRequest:(InvokeRPCRequest *)request handler:(void(^)(InvokeRPCResponse *_Nullable response, NSError *_Nullable error))handler{
  [[self RPCToPreExecWithRequest:request handler:handler] start];
}
// Returns a not-yet-started RPC object.
/**
 * 预执行合约
 *
 * This method belongs to a set of APIs that have been deprecated. Using the v2 API is recommended.
 */
- (GRPCProtoCall *)RPCToPreExecWithRequest:(InvokeRPCRequest *)request handler:(void(^)(InvokeRPCResponse *_Nullable response, NSError *_Nullable error))handler{
  return [self RPCToMethod:@"PreExec"
            requestsWriter:[GRXWriter writerWithValue:request]
             responseClass:[InvokeRPCResponse class]
        responsesWriteable:[GRXWriteable writeableWithSingleHandler:handler]];
}
/**
 * 预执行合约
 */
- (GRPCUnaryProtoCall *)preExecWithMessage:(InvokeRPCRequest *)message responseHandler:(id<GRPCProtoResponseHandler>)handler callOptions:(GRPCCallOptions *_Nullable)callOptions {
  return [self RPCToMethod:@"PreExec"
                   message:message
           responseHandler:handler
               callOptions:callOptions
             responseClass:[InvokeRPCResponse class]];
}

@end
#endif
