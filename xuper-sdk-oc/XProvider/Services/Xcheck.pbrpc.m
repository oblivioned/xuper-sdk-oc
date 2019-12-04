#if !defined(GPB_GRPC_PROTOCOL_ONLY) || !GPB_GRPC_PROTOCOL_ONLY
#import "Xcheck.pbrpc.h"
#import "Xcheck.pbobjc.h"
#import <ProtoRPC/ProtoRPCLegacy.h>
#import <RxLibrary/GRXWriter+Immediate.h>

#import "Xchain.pbobjc.h"

@implementation Xcheck

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-designated-initializers"

// Designated initializer
- (instancetype)initWithHost:(NSString *)host callOptions:(GRPCCallOptions *_Nullable)callOptions {
  return [super initWithHost:host
                 packageName:@"pb"
                 serviceName:@"Xcheck"
                 callOptions:callOptions];
}

- (instancetype)initWithHost:(NSString *)host {
  return [super initWithHost:host
                 packageName:@"pb"
                 serviceName:@"Xcheck"];
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

#pragma mark ComplianceCheck(TxStatus) returns (ComplianceCheckResponse)

- (void)complianceCheckWithRequest:(TxStatus *)request handler:(void(^)(ComplianceCheckResponse *_Nullable response, NSError *_Nullable error))handler{
  [[self RPCToComplianceCheckWithRequest:request handler:handler] start];
}
// Returns a not-yet-started RPC object.
- (GRPCProtoCall *)RPCToComplianceCheckWithRequest:(TxStatus *)request handler:(void(^)(ComplianceCheckResponse *_Nullable response, NSError *_Nullable error))handler{
  return [self RPCToMethod:@"ComplianceCheck"
            requestsWriter:[GRXWriter writerWithValue:request]
             responseClass:[ComplianceCheckResponse class]
        responsesWriteable:[GRXWriteable writeableWithSingleHandler:handler]];
}
- (GRPCUnaryProtoCall *)complianceCheckWithMessage:(TxStatus *)message responseHandler:(id<GRPCProtoResponseHandler>)handler callOptions:(GRPCCallOptions *_Nullable)callOptions {
  return [self RPCToMethod:@"ComplianceCheck"
                   message:message
           responseHandler:handler
               callOptions:callOptions
             responseClass:[ComplianceCheckResponse class]];
}

#pragma mark TransferCheck(TxStatus) returns (TransferCheckResponse)

- (void)transferCheckWithRequest:(TxStatus *)request handler:(void(^)(TransferCheckResponse *_Nullable response, NSError *_Nullable error))handler{
  [[self RPCToTransferCheckWithRequest:request handler:handler] start];
}
// Returns a not-yet-started RPC object.
- (GRPCProtoCall *)RPCToTransferCheckWithRequest:(TxStatus *)request handler:(void(^)(TransferCheckResponse *_Nullable response, NSError *_Nullable error))handler{
  return [self RPCToMethod:@"TransferCheck"
            requestsWriter:[GRXWriter writerWithValue:request]
             responseClass:[TransferCheckResponse class]
        responsesWriteable:[GRXWriteable writeableWithSingleHandler:handler]];
}
- (GRPCUnaryProtoCall *)transferCheckWithMessage:(TxStatus *)message responseHandler:(id<GRPCProtoResponseHandler>)handler callOptions:(GRPCCallOptions *_Nullable)callOptions {
  return [self RPCToMethod:@"TransferCheck"
                   message:message
           responseHandler:handler
               callOptions:callOptions
             responseClass:[TransferCheckResponse class]];
}

@end
#endif
