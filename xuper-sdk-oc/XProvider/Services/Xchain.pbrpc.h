#if !defined(GPB_GRPC_FORWARD_DECLARE_MESSAGE_PROTO) || !GPB_GRPC_FORWARD_DECLARE_MESSAGE_PROTO
#import "Xchain.pbobjc.h"
#endif

#if !defined(GPB_GRPC_PROTOCOL_ONLY) || !GPB_GRPC_PROTOCOL_ONLY
#import <ProtoRPC/ProtoService.h>
#import <ProtoRPC/ProtoRPCLegacy.h>
#import <RxLibrary/GRXWriteable.h>
#import <RxLibrary/GRXWriter.h>
#endif

@class AK2AccountRequest;
@class AK2AccountResponse;
@class AclStatus;
@class AddressBalanceStatus;
@class AddressStatus;
@class BCStatus;
@class Block;
@class BlockChains;
@class BlockHeight;
@class BlockID;
@class CommonIn;
@class CommonReply;
@class DeployNativeCodeRequest;
@class DeployNativeCodeResponse;
@class DposCandidatesRequest;
@class DposCandidatesResponse;
@class DposCheckResultsRequest;
@class DposCheckResultsResponse;
@class DposNominateRecordsRequest;
@class DposNominateRecordsResponse;
@class DposNomineeRecordsRequest;
@class DposNomineeRecordsResponse;
@class DposStatusRequest;
@class DposStatusResponse;
@class DposVoteRecordsRequest;
@class DposVoteRecordsResponse;
@class DposVotedRecordsRequest;
@class DposVotedRecordsResponse;
@class GetAccountContractsRequest;
@class GetAccountContractsResponse;
@class InvokeRPCRequest;
@class InvokeRPCResponse;
@class NativeCodeStatusRequest;
@class NativeCodeStatusResponse;
@class PreExecWithSelectUTXORequest;
@class PreExecWithSelectUTXOResponse;
@class RawUrl;
@class SystemsStatusReply;
@class TxStatus;
@class UtxoInput;
@class UtxoOutput;

#if !defined(GPB_GRPC_FORWARD_DECLARE_MESSAGE_PROTO) || !GPB_GRPC_FORWARD_DECLARE_MESSAGE_PROTO
  #import "Chainedbft.pbobjc.h"
#endif

@class GRPCUnaryProtoCall;
@class GRPCStreamingProtoCall;
@class GRPCCallOptions;
@protocol GRPCProtoResponseHandler;
@class GRPCProtoCall;


NS_ASSUME_NONNULL_BEGIN

@protocol Xchain2 <NSObject>

#pragma mark PostTx(TxStatus) returns (CommonReply)

/**
 * PostTx post Transaction to a node
 */
- (GRPCUnaryProtoCall *)postTxWithMessage:(TxStatus *)message responseHandler:(id<GRPCProtoResponseHandler>)handler callOptions:(GRPCCallOptions *_Nullable)callOptions;

#pragma mark QueryACL(AclStatus) returns (AclStatus)

- (GRPCUnaryProtoCall *)queryACLWithMessage:(AclStatus *)message responseHandler:(id<GRPCProtoResponseHandler>)handler callOptions:(GRPCCallOptions *_Nullable)callOptions;

#pragma mark GetAccountContracts(GetAccountContractsRequest) returns (GetAccountContractsResponse)

- (GRPCUnaryProtoCall *)getAccountContractsWithMessage:(GetAccountContractsRequest *)message responseHandler:(id<GRPCProtoResponseHandler>)handler callOptions:(GRPCCallOptions *_Nullable)callOptions;

#pragma mark QueryTx(TxStatus) returns (TxStatus)

/**
 * QueryTx query Transaction by TxStatus,
 * Bcname and Txid are required for this
 */
- (GRPCUnaryProtoCall *)queryTxWithMessage:(TxStatus *)message responseHandler:(id<GRPCProtoResponseHandler>)handler callOptions:(GRPCCallOptions *_Nullable)callOptions;

#pragma mark GetBalance(AddressStatus) returns (AddressStatus)

/**
 * GetBalance get balance of an address,
 * Address is required for this
 */
- (GRPCUnaryProtoCall *)getBalanceWithMessage:(AddressStatus *)message responseHandler:(id<GRPCProtoResponseHandler>)handler callOptions:(GRPCCallOptions *_Nullable)callOptions;

#pragma mark GetBalanceDetail(AddressBalanceStatus) returns (AddressBalanceStatus)

/**
 * GetFrozenBalance get two kinds of balance
 * 1. Still be frozen of an address
 * 2. Available now of an address
 * Address is required for this
 */
- (GRPCUnaryProtoCall *)getBalanceDetailWithMessage:(AddressBalanceStatus *)message responseHandler:(id<GRPCProtoResponseHandler>)handler callOptions:(GRPCCallOptions *_Nullable)callOptions;

#pragma mark GetFrozenBalance(AddressStatus) returns (AddressStatus)

/**
 * GetFrozenBalance get balance that still be frozen of an address,
 * Address is required for this
 */
- (GRPCUnaryProtoCall *)getFrozenBalanceWithMessage:(AddressStatus *)message responseHandler:(id<GRPCProtoResponseHandler>)handler callOptions:(GRPCCallOptions *_Nullable)callOptions;

#pragma mark GetBlock(BlockID) returns (Block)

/**
 * GetBlock get block by blockid and return if the block in trunk or in branch
 */
- (GRPCUnaryProtoCall *)getBlockWithMessage:(BlockID *)message responseHandler:(id<GRPCProtoResponseHandler>)handler callOptions:(GRPCCallOptions *_Nullable)callOptions;

#pragma mark GetBlockByHeight(BlockHeight) returns (Block)

/**
 * GetBlockByHeight get block by height and return if the block in trunk or in
 * branch
 */
- (GRPCUnaryProtoCall *)getBlockByHeightWithMessage:(BlockHeight *)message responseHandler:(id<GRPCProtoResponseHandler>)handler callOptions:(GRPCCallOptions *_Nullable)callOptions;

#pragma mark GetBlockChainStatus(BCStatus) returns (BCStatus)

- (GRPCUnaryProtoCall *)getBlockChainStatusWithMessage:(BCStatus *)message responseHandler:(id<GRPCProtoResponseHandler>)handler callOptions:(GRPCCallOptions *_Nullable)callOptions;

#pragma mark GetBlockChains(CommonIn) returns (BlockChains)

/**
 * Get blockchains query blockchains
 */
- (GRPCUnaryProtoCall *)getBlockChainsWithMessage:(CommonIn *)message responseHandler:(id<GRPCProtoResponseHandler>)handler callOptions:(GRPCCallOptions *_Nullable)callOptions;

#pragma mark GetSystemStatus(CommonIn) returns (SystemsStatusReply)

/**
 * GetSystemStatus query system status
 */
- (GRPCUnaryProtoCall *)getSystemStatusWithMessage:(CommonIn *)message responseHandler:(id<GRPCProtoResponseHandler>)handler callOptions:(GRPCCallOptions *_Nullable)callOptions;

#pragma mark GetNetURL(CommonIn) returns (RawUrl)

/**
 * GetNetURL return net url
 */
- (GRPCUnaryProtoCall *)getNetURLWithMessage:(CommonIn *)message responseHandler:(id<GRPCProtoResponseHandler>)handler callOptions:(GRPCCallOptions *_Nullable)callOptions;

#pragma mark SelectUTXO(UtxoInput) returns (UtxoOutput)

/**
 * 新的Select utxos接口, 不需要签名，可以支持选择账户的utxo
 */
- (GRPCUnaryProtoCall *)selectUTXOWithMessage:(UtxoInput *)message responseHandler:(id<GRPCProtoResponseHandler>)handler callOptions:(GRPCCallOptions *_Nullable)callOptions;

#pragma mark PreExecWithSelectUTXO(PreExecWithSelectUTXORequest) returns (PreExecWithSelectUTXOResponse)

/**
 * PreExecWithSelectUTXO preExec & selectUtxo
 */
- (GRPCUnaryProtoCall *)preExecWithSelectUTXOWithMessage:(PreExecWithSelectUTXORequest *)message responseHandler:(id<GRPCProtoResponseHandler>)handler callOptions:(GRPCCallOptions *_Nullable)callOptions;

#pragma mark DeployNativeCode(DeployNativeCodeRequest) returns (DeployNativeCodeResponse)

/**
 * Native code deploy interface
 */
- (GRPCUnaryProtoCall *)deployNativeCodeWithMessage:(DeployNativeCodeRequest *)message responseHandler:(id<GRPCProtoResponseHandler>)handler callOptions:(GRPCCallOptions *_Nullable)callOptions;

#pragma mark NativeCodeStatus(NativeCodeStatusRequest) returns (NativeCodeStatusResponse)

/**
 * Native code status
 */
- (GRPCUnaryProtoCall *)nativeCodeStatusWithMessage:(NativeCodeStatusRequest *)message responseHandler:(id<GRPCProtoResponseHandler>)handler callOptions:(GRPCCallOptions *_Nullable)callOptions;

#pragma mark DposCandidates(DposCandidatesRequest) returns (DposCandidatesResponse)

/**
 * 
 * DPoS query interface
 * 
 * DposCandidates get all candidates of the tdpos consensus
 */
- (GRPCUnaryProtoCall *)dposCandidatesWithMessage:(DposCandidatesRequest *)message responseHandler:(id<GRPCProtoResponseHandler>)handler callOptions:(GRPCCallOptions *_Nullable)callOptions;

#pragma mark DposNominateRecords(DposNominateRecordsRequest) returns (DposNominateRecordsResponse)

/**
 * DposNominateRecords get all records nominated by an user
 */
- (GRPCUnaryProtoCall *)dposNominateRecordsWithMessage:(DposNominateRecordsRequest *)message responseHandler:(id<GRPCProtoResponseHandler>)handler callOptions:(GRPCCallOptions *_Nullable)callOptions;

#pragma mark DposNomineeRecords(DposNomineeRecordsRequest) returns (DposNomineeRecordsResponse)

/**
 * DposNomineeRecords get nominated record of a candidate
 */
- (GRPCUnaryProtoCall *)dposNomineeRecordsWithMessage:(DposNomineeRecordsRequest *)message responseHandler:(id<GRPCProtoResponseHandler>)handler callOptions:(GRPCCallOptions *_Nullable)callOptions;

#pragma mark DposVoteRecords(DposVoteRecordsRequest) returns (DposVoteRecordsResponse)

/**
 * DposVoteRecords get all vote records voted by an user
 */
- (GRPCUnaryProtoCall *)dposVoteRecordsWithMessage:(DposVoteRecordsRequest *)message responseHandler:(id<GRPCProtoResponseHandler>)handler callOptions:(GRPCCallOptions *_Nullable)callOptions;

#pragma mark DposVotedRecords(DposVotedRecordsRequest) returns (DposVotedRecordsResponse)

/**
 * DposVotedRecords get all vote records of a candidate
 */
- (GRPCUnaryProtoCall *)dposVotedRecordsWithMessage:(DposVotedRecordsRequest *)message responseHandler:(id<GRPCProtoResponseHandler>)handler callOptions:(GRPCCallOptions *_Nullable)callOptions;

#pragma mark DposCheckResults(DposCheckResultsRequest) returns (DposCheckResultsResponse)

/**
 * DposCheckResults get check results of a specific term
 */
- (GRPCUnaryProtoCall *)dposCheckResultsWithMessage:(DposCheckResultsRequest *)message responseHandler:(id<GRPCProtoResponseHandler>)handler callOptions:(GRPCCallOptions *_Nullable)callOptions;

#pragma mark DposStatus(DposStatusRequest) returns (DposStatusResponse)

/**
 * DposStatus get dpos status
 */
- (GRPCUnaryProtoCall *)dposStatusWithMessage:(DposStatusRequest *)message responseHandler:(id<GRPCProtoResponseHandler>)handler callOptions:(GRPCCallOptions *_Nullable)callOptions;

#pragma mark GetAccountByAK(AK2AccountRequest) returns (AK2AccountResponse)

/**
 * GetAccountByAK get account sets contain a specific address
 */
- (GRPCUnaryProtoCall *)getAccountByAKWithMessage:(AK2AccountRequest *)message responseHandler:(id<GRPCProtoResponseHandler>)handler callOptions:(GRPCCallOptions *_Nullable)callOptions;

#pragma mark PreExec(InvokeRPCRequest) returns (InvokeRPCResponse)

/**
 * 预执行合约
 */
- (GRPCUnaryProtoCall *)preExecWithMessage:(InvokeRPCRequest *)message responseHandler:(id<GRPCProtoResponseHandler>)handler callOptions:(GRPCCallOptions *_Nullable)callOptions;

@end

/**
 * The methods in this protocol belong to a set of old APIs that have been deprecated. They do not
 * recognize call options provided in the initializer. Using the v2 protocol is recommended.
 */
@protocol Xchain <NSObject>

#pragma mark PostTx(TxStatus) returns (CommonReply)

/**
 * PostTx post Transaction to a node
 *
 * This method belongs to a set of APIs that have been deprecated. Using the v2 API is recommended.
 */
- (void)postTxWithRequest:(TxStatus *)request handler:(void(^)(CommonReply *_Nullable response, NSError *_Nullable error))handler;

/**
 * PostTx post Transaction to a node
 *
 * This method belongs to a set of APIs that have been deprecated. Using the v2 API is recommended.
 */
- (GRPCProtoCall *)RPCToPostTxWithRequest:(TxStatus *)request handler:(void(^)(CommonReply *_Nullable response, NSError *_Nullable error))handler;


#pragma mark QueryACL(AclStatus) returns (AclStatus)

- (void)queryACLWithRequest:(AclStatus *)request handler:(void(^)(AclStatus *_Nullable response, NSError *_Nullable error))handler;

- (GRPCProtoCall *)RPCToQueryACLWithRequest:(AclStatus *)request handler:(void(^)(AclStatus *_Nullable response, NSError *_Nullable error))handler;


#pragma mark GetAccountContracts(GetAccountContractsRequest) returns (GetAccountContractsResponse)

- (void)getAccountContractsWithRequest:(GetAccountContractsRequest *)request handler:(void(^)(GetAccountContractsResponse *_Nullable response, NSError *_Nullable error))handler;

- (GRPCProtoCall *)RPCToGetAccountContractsWithRequest:(GetAccountContractsRequest *)request handler:(void(^)(GetAccountContractsResponse *_Nullable response, NSError *_Nullable error))handler;


#pragma mark QueryTx(TxStatus) returns (TxStatus)

/**
 * QueryTx query Transaction by TxStatus,
 * Bcname and Txid are required for this
 *
 * This method belongs to a set of APIs that have been deprecated. Using the v2 API is recommended.
 */
- (void)queryTxWithRequest:(TxStatus *)request handler:(void(^)(TxStatus *_Nullable response, NSError *_Nullable error))handler;

/**
 * QueryTx query Transaction by TxStatus,
 * Bcname and Txid are required for this
 *
 * This method belongs to a set of APIs that have been deprecated. Using the v2 API is recommended.
 */
- (GRPCProtoCall *)RPCToQueryTxWithRequest:(TxStatus *)request handler:(void(^)(TxStatus *_Nullable response, NSError *_Nullable error))handler;


#pragma mark GetBalance(AddressStatus) returns (AddressStatus)

/**
 * GetBalance get balance of an address,
 * Address is required for this
 *
 * This method belongs to a set of APIs that have been deprecated. Using the v2 API is recommended.
 */
- (void)getBalanceWithRequest:(AddressStatus *)request handler:(void(^)(AddressStatus *_Nullable response, NSError *_Nullable error))handler;

/**
 * GetBalance get balance of an address,
 * Address is required for this
 *
 * This method belongs to a set of APIs that have been deprecated. Using the v2 API is recommended.
 */
- (GRPCProtoCall *)RPCToGetBalanceWithRequest:(AddressStatus *)request handler:(void(^)(AddressStatus *_Nullable response, NSError *_Nullable error))handler;


#pragma mark GetBalanceDetail(AddressBalanceStatus) returns (AddressBalanceStatus)

/**
 * GetFrozenBalance get two kinds of balance
 * 1. Still be frozen of an address
 * 2. Available now of an address
 * Address is required for this
 *
 * This method belongs to a set of APIs that have been deprecated. Using the v2 API is recommended.
 */
- (void)getBalanceDetailWithRequest:(AddressBalanceStatus *)request handler:(void(^)(AddressBalanceStatus *_Nullable response, NSError *_Nullable error))handler;

/**
 * GetFrozenBalance get two kinds of balance
 * 1. Still be frozen of an address
 * 2. Available now of an address
 * Address is required for this
 *
 * This method belongs to a set of APIs that have been deprecated. Using the v2 API is recommended.
 */
- (GRPCProtoCall *)RPCToGetBalanceDetailWithRequest:(AddressBalanceStatus *)request handler:(void(^)(AddressBalanceStatus *_Nullable response, NSError *_Nullable error))handler;


#pragma mark GetFrozenBalance(AddressStatus) returns (AddressStatus)

/**
 * GetFrozenBalance get balance that still be frozen of an address,
 * Address is required for this
 *
 * This method belongs to a set of APIs that have been deprecated. Using the v2 API is recommended.
 */
- (void)getFrozenBalanceWithRequest:(AddressStatus *)request handler:(void(^)(AddressStatus *_Nullable response, NSError *_Nullable error))handler;

/**
 * GetFrozenBalance get balance that still be frozen of an address,
 * Address is required for this
 *
 * This method belongs to a set of APIs that have been deprecated. Using the v2 API is recommended.
 */
- (GRPCProtoCall *)RPCToGetFrozenBalanceWithRequest:(AddressStatus *)request handler:(void(^)(AddressStatus *_Nullable response, NSError *_Nullable error))handler;


#pragma mark GetBlock(BlockID) returns (Block)

/**
 * GetBlock get block by blockid and return if the block in trunk or in branch
 *
 * This method belongs to a set of APIs that have been deprecated. Using the v2 API is recommended.
 */
- (void)getBlockWithRequest:(BlockID *)request handler:(void(^)(Block *_Nullable response, NSError *_Nullable error))handler;

/**
 * GetBlock get block by blockid and return if the block in trunk or in branch
 *
 * This method belongs to a set of APIs that have been deprecated. Using the v2 API is recommended.
 */
- (GRPCProtoCall *)RPCToGetBlockWithRequest:(BlockID *)request handler:(void(^)(Block *_Nullable response, NSError *_Nullable error))handler;


#pragma mark GetBlockByHeight(BlockHeight) returns (Block)

/**
 * GetBlockByHeight get block by height and return if the block in trunk or in
 * branch
 *
 * This method belongs to a set of APIs that have been deprecated. Using the v2 API is recommended.
 */
- (void)getBlockByHeightWithRequest:(BlockHeight *)request handler:(void(^)(Block *_Nullable response, NSError *_Nullable error))handler;

/**
 * GetBlockByHeight get block by height and return if the block in trunk or in
 * branch
 *
 * This method belongs to a set of APIs that have been deprecated. Using the v2 API is recommended.
 */
- (GRPCProtoCall *)RPCToGetBlockByHeightWithRequest:(BlockHeight *)request handler:(void(^)(Block *_Nullable response, NSError *_Nullable error))handler;


#pragma mark GetBlockChainStatus(BCStatus) returns (BCStatus)

- (void)getBlockChainStatusWithRequest:(BCStatus *)request handler:(void(^)(BCStatus *_Nullable response, NSError *_Nullable error))handler;

- (GRPCProtoCall *)RPCToGetBlockChainStatusWithRequest:(BCStatus *)request handler:(void(^)(BCStatus *_Nullable response, NSError *_Nullable error))handler;


#pragma mark GetBlockChains(CommonIn) returns (BlockChains)

/**
 * Get blockchains query blockchains
 *
 * This method belongs to a set of APIs that have been deprecated. Using the v2 API is recommended.
 */
- (void)getBlockChainsWithRequest:(CommonIn *)request handler:(void(^)(BlockChains *_Nullable response, NSError *_Nullable error))handler;

/**
 * Get blockchains query blockchains
 *
 * This method belongs to a set of APIs that have been deprecated. Using the v2 API is recommended.
 */
- (GRPCProtoCall *)RPCToGetBlockChainsWithRequest:(CommonIn *)request handler:(void(^)(BlockChains *_Nullable response, NSError *_Nullable error))handler;


#pragma mark GetSystemStatus(CommonIn) returns (SystemsStatusReply)

/**
 * GetSystemStatus query system status
 *
 * This method belongs to a set of APIs that have been deprecated. Using the v2 API is recommended.
 */
- (void)getSystemStatusWithRequest:(CommonIn *)request handler:(void(^)(SystemsStatusReply *_Nullable response, NSError *_Nullable error))handler;

/**
 * GetSystemStatus query system status
 *
 * This method belongs to a set of APIs that have been deprecated. Using the v2 API is recommended.
 */
- (GRPCProtoCall *)RPCToGetSystemStatusWithRequest:(CommonIn *)request handler:(void(^)(SystemsStatusReply *_Nullable response, NSError *_Nullable error))handler;


#pragma mark GetNetURL(CommonIn) returns (RawUrl)

/**
 * GetNetURL return net url
 *
 * This method belongs to a set of APIs that have been deprecated. Using the v2 API is recommended.
 */
- (void)getNetURLWithRequest:(CommonIn *)request handler:(void(^)(RawUrl *_Nullable response, NSError *_Nullable error))handler;

/**
 * GetNetURL return net url
 *
 * This method belongs to a set of APIs that have been deprecated. Using the v2 API is recommended.
 */
- (GRPCProtoCall *)RPCToGetNetURLWithRequest:(CommonIn *)request handler:(void(^)(RawUrl *_Nullable response, NSError *_Nullable error))handler;


#pragma mark SelectUTXO(UtxoInput) returns (UtxoOutput)

/**
 * 新的Select utxos接口, 不需要签名，可以支持选择账户的utxo
 *
 * This method belongs to a set of APIs that have been deprecated. Using the v2 API is recommended.
 */
- (void)selectUTXOWithRequest:(UtxoInput *)request handler:(void(^)(UtxoOutput *_Nullable response, NSError *_Nullable error))handler;

/**
 * 新的Select utxos接口, 不需要签名，可以支持选择账户的utxo
 *
 * This method belongs to a set of APIs that have been deprecated. Using the v2 API is recommended.
 */
- (GRPCProtoCall *)RPCToSelectUTXOWithRequest:(UtxoInput *)request handler:(void(^)(UtxoOutput *_Nullable response, NSError *_Nullable error))handler;


#pragma mark PreExecWithSelectUTXO(PreExecWithSelectUTXORequest) returns (PreExecWithSelectUTXOResponse)

/**
 * PreExecWithSelectUTXO preExec & selectUtxo
 *
 * This method belongs to a set of APIs that have been deprecated. Using the v2 API is recommended.
 */
- (void)preExecWithSelectUTXOWithRequest:(PreExecWithSelectUTXORequest *)request handler:(void(^)(PreExecWithSelectUTXOResponse *_Nullable response, NSError *_Nullable error))handler;

/**
 * PreExecWithSelectUTXO preExec & selectUtxo
 *
 * This method belongs to a set of APIs that have been deprecated. Using the v2 API is recommended.
 */
- (GRPCProtoCall *)RPCToPreExecWithSelectUTXOWithRequest:(PreExecWithSelectUTXORequest *)request handler:(void(^)(PreExecWithSelectUTXOResponse *_Nullable response, NSError *_Nullable error))handler;


#pragma mark DeployNativeCode(DeployNativeCodeRequest) returns (DeployNativeCodeResponse)

/**
 * Native code deploy interface
 *
 * This method belongs to a set of APIs that have been deprecated. Using the v2 API is recommended.
 */
- (void)deployNativeCodeWithRequest:(DeployNativeCodeRequest *)request handler:(void(^)(DeployNativeCodeResponse *_Nullable response, NSError *_Nullable error))handler;

/**
 * Native code deploy interface
 *
 * This method belongs to a set of APIs that have been deprecated. Using the v2 API is recommended.
 */
- (GRPCProtoCall *)RPCToDeployNativeCodeWithRequest:(DeployNativeCodeRequest *)request handler:(void(^)(DeployNativeCodeResponse *_Nullable response, NSError *_Nullable error))handler;


#pragma mark NativeCodeStatus(NativeCodeStatusRequest) returns (NativeCodeStatusResponse)

/**
 * Native code status
 *
 * This method belongs to a set of APIs that have been deprecated. Using the v2 API is recommended.
 */
- (void)nativeCodeStatusWithRequest:(NativeCodeStatusRequest *)request handler:(void(^)(NativeCodeStatusResponse *_Nullable response, NSError *_Nullable error))handler;

/**
 * Native code status
 *
 * This method belongs to a set of APIs that have been deprecated. Using the v2 API is recommended.
 */
- (GRPCProtoCall *)RPCToNativeCodeStatusWithRequest:(NativeCodeStatusRequest *)request handler:(void(^)(NativeCodeStatusResponse *_Nullable response, NSError *_Nullable error))handler;


#pragma mark DposCandidates(DposCandidatesRequest) returns (DposCandidatesResponse)

/**
 * 
 * DPoS query interface
 * 
 * DposCandidates get all candidates of the tdpos consensus
 *
 * This method belongs to a set of APIs that have been deprecated. Using the v2 API is recommended.
 */
- (void)dposCandidatesWithRequest:(DposCandidatesRequest *)request handler:(void(^)(DposCandidatesResponse *_Nullable response, NSError *_Nullable error))handler;

/**
 * 
 * DPoS query interface
 * 
 * DposCandidates get all candidates of the tdpos consensus
 *
 * This method belongs to a set of APIs that have been deprecated. Using the v2 API is recommended.
 */
- (GRPCProtoCall *)RPCToDposCandidatesWithRequest:(DposCandidatesRequest *)request handler:(void(^)(DposCandidatesResponse *_Nullable response, NSError *_Nullable error))handler;


#pragma mark DposNominateRecords(DposNominateRecordsRequest) returns (DposNominateRecordsResponse)

/**
 * DposNominateRecords get all records nominated by an user
 *
 * This method belongs to a set of APIs that have been deprecated. Using the v2 API is recommended.
 */
- (void)dposNominateRecordsWithRequest:(DposNominateRecordsRequest *)request handler:(void(^)(DposNominateRecordsResponse *_Nullable response, NSError *_Nullable error))handler;

/**
 * DposNominateRecords get all records nominated by an user
 *
 * This method belongs to a set of APIs that have been deprecated. Using the v2 API is recommended.
 */
- (GRPCProtoCall *)RPCToDposNominateRecordsWithRequest:(DposNominateRecordsRequest *)request handler:(void(^)(DposNominateRecordsResponse *_Nullable response, NSError *_Nullable error))handler;


#pragma mark DposNomineeRecords(DposNomineeRecordsRequest) returns (DposNomineeRecordsResponse)

/**
 * DposNomineeRecords get nominated record of a candidate
 *
 * This method belongs to a set of APIs that have been deprecated. Using the v2 API is recommended.
 */
- (void)dposNomineeRecordsWithRequest:(DposNomineeRecordsRequest *)request handler:(void(^)(DposNomineeRecordsResponse *_Nullable response, NSError *_Nullable error))handler;

/**
 * DposNomineeRecords get nominated record of a candidate
 *
 * This method belongs to a set of APIs that have been deprecated. Using the v2 API is recommended.
 */
- (GRPCProtoCall *)RPCToDposNomineeRecordsWithRequest:(DposNomineeRecordsRequest *)request handler:(void(^)(DposNomineeRecordsResponse *_Nullable response, NSError *_Nullable error))handler;


#pragma mark DposVoteRecords(DposVoteRecordsRequest) returns (DposVoteRecordsResponse)

/**
 * DposVoteRecords get all vote records voted by an user
 *
 * This method belongs to a set of APIs that have been deprecated. Using the v2 API is recommended.
 */
- (void)dposVoteRecordsWithRequest:(DposVoteRecordsRequest *)request handler:(void(^)(DposVoteRecordsResponse *_Nullable response, NSError *_Nullable error))handler;

/**
 * DposVoteRecords get all vote records voted by an user
 *
 * This method belongs to a set of APIs that have been deprecated. Using the v2 API is recommended.
 */
- (GRPCProtoCall *)RPCToDposVoteRecordsWithRequest:(DposVoteRecordsRequest *)request handler:(void(^)(DposVoteRecordsResponse *_Nullable response, NSError *_Nullable error))handler;


#pragma mark DposVotedRecords(DposVotedRecordsRequest) returns (DposVotedRecordsResponse)

/**
 * DposVotedRecords get all vote records of a candidate
 *
 * This method belongs to a set of APIs that have been deprecated. Using the v2 API is recommended.
 */
- (void)dposVotedRecordsWithRequest:(DposVotedRecordsRequest *)request handler:(void(^)(DposVotedRecordsResponse *_Nullable response, NSError *_Nullable error))handler;

/**
 * DposVotedRecords get all vote records of a candidate
 *
 * This method belongs to a set of APIs that have been deprecated. Using the v2 API is recommended.
 */
- (GRPCProtoCall *)RPCToDposVotedRecordsWithRequest:(DposVotedRecordsRequest *)request handler:(void(^)(DposVotedRecordsResponse *_Nullable response, NSError *_Nullable error))handler;


#pragma mark DposCheckResults(DposCheckResultsRequest) returns (DposCheckResultsResponse)

/**
 * DposCheckResults get check results of a specific term
 *
 * This method belongs to a set of APIs that have been deprecated. Using the v2 API is recommended.
 */
- (void)dposCheckResultsWithRequest:(DposCheckResultsRequest *)request handler:(void(^)(DposCheckResultsResponse *_Nullable response, NSError *_Nullable error))handler;

/**
 * DposCheckResults get check results of a specific term
 *
 * This method belongs to a set of APIs that have been deprecated. Using the v2 API is recommended.
 */
- (GRPCProtoCall *)RPCToDposCheckResultsWithRequest:(DposCheckResultsRequest *)request handler:(void(^)(DposCheckResultsResponse *_Nullable response, NSError *_Nullable error))handler;


#pragma mark DposStatus(DposStatusRequest) returns (DposStatusResponse)

/**
 * DposStatus get dpos status
 *
 * This method belongs to a set of APIs that have been deprecated. Using the v2 API is recommended.
 */
- (void)dposStatusWithRequest:(DposStatusRequest *)request handler:(void(^)(DposStatusResponse *_Nullable response, NSError *_Nullable error))handler;

/**
 * DposStatus get dpos status
 *
 * This method belongs to a set of APIs that have been deprecated. Using the v2 API is recommended.
 */
- (GRPCProtoCall *)RPCToDposStatusWithRequest:(DposStatusRequest *)request handler:(void(^)(DposStatusResponse *_Nullable response, NSError *_Nullable error))handler;


#pragma mark GetAccountByAK(AK2AccountRequest) returns (AK2AccountResponse)

/**
 * GetAccountByAK get account sets contain a specific address
 *
 * This method belongs to a set of APIs that have been deprecated. Using the v2 API is recommended.
 */
- (void)getAccountByAKWithRequest:(AK2AccountRequest *)request handler:(void(^)(AK2AccountResponse *_Nullable response, NSError *_Nullable error))handler;

/**
 * GetAccountByAK get account sets contain a specific address
 *
 * This method belongs to a set of APIs that have been deprecated. Using the v2 API is recommended.
 */
- (GRPCProtoCall *)RPCToGetAccountByAKWithRequest:(AK2AccountRequest *)request handler:(void(^)(AK2AccountResponse *_Nullable response, NSError *_Nullable error))handler;


#pragma mark PreExec(InvokeRPCRequest) returns (InvokeRPCResponse)

/**
 * 预执行合约
 *
 * This method belongs to a set of APIs that have been deprecated. Using the v2 API is recommended.
 */
- (void)preExecWithRequest:(InvokeRPCRequest *)request handler:(void(^)(InvokeRPCResponse *_Nullable response, NSError *_Nullable error))handler;

/**
 * 预执行合约
 *
 * This method belongs to a set of APIs that have been deprecated. Using the v2 API is recommended.
 */
- (GRPCProtoCall *)RPCToPreExecWithRequest:(InvokeRPCRequest *)request handler:(void(^)(InvokeRPCResponse *_Nullable response, NSError *_Nullable error))handler;


@end


#if !defined(GPB_GRPC_PROTOCOL_ONLY) || !GPB_GRPC_PROTOCOL_ONLY
/**
 * Basic service implementation, over gRPC, that only does
 * marshalling and parsing.
 */
@interface Xchain : GRPCProtoService<Xchain2, Xchain>
- (instancetype)initWithHost:(NSString *)host callOptions:(GRPCCallOptions *_Nullable)callOptions NS_DESIGNATED_INITIALIZER;
+ (instancetype)serviceWithHost:(NSString *)host callOptions:(GRPCCallOptions *_Nullable)callOptions;
// The following methods belong to a set of old APIs that have been deprecated.
- (instancetype)initWithHost:(NSString *)host;
+ (instancetype)serviceWithHost:(NSString *)host;
@end
#endif

NS_ASSUME_NONNULL_END

