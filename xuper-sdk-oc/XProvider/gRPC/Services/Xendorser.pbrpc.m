#if !defined(GPB_GRPC_PROTOCOL_ONLY) || !GPB_GRPC_PROTOCOL_ONLY
#import "Xendorser.pbrpc.h"
#import "Xendorser.pbobjc.h"
#import <ProtoRPC/ProtoRPCLegacy.h>
#import <RxLibrary/GRXWriter+Immediate.h>

#import "Xchain.pbobjc.h"
#import "google/api/Annotations.pbobjc.h"

@implementation xendorser

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-designated-initializers"

// Designated initializer
- (instancetype)initWithHost:(NSString *)host callOptions:(GRPCCallOptions *_Nullable)callOptions {
  return [super initWithHost:host
                 packageName:@"pb"
                 serviceName:@"xendorser"
                 callOptions:callOptions];
}

- (instancetype)initWithHost:(NSString *)host {
  return [super initWithHost:host
                 packageName:@"pb"
                 serviceName:@"xendorser"];
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

#pragma mark EndorserCall(EndorserRequest) returns (EndorserResponse)

- (void)endorserCallWithRequest:(EndorserRequest *)request handler:(void(^)(EndorserResponse *_Nullable response, NSError *_Nullable error))handler{
  [[self RPCToEndorserCallWithRequest:request handler:handler] start];
}
// Returns a not-yet-started RPC object.
- (GRPCProtoCall *)RPCToEndorserCallWithRequest:(EndorserRequest *)request handler:(void(^)(EndorserResponse *_Nullable response, NSError *_Nullable error))handler{
  return [self RPCToMethod:@"EndorserCall"
            requestsWriter:[GRXWriter writerWithValue:request]
             responseClass:[EndorserResponse class]
        responsesWriteable:[GRXWriteable writeableWithSingleHandler:handler]];
}
- (GRPCUnaryProtoCall *)endorserCallWithMessage:(EndorserRequest *)message responseHandler:(id<GRPCProtoResponseHandler>)handler callOptions:(GRPCCallOptions *_Nullable)callOptions {
  return [self RPCToMethod:@"EndorserCall"
                   message:message
           responseHandler:handler
               callOptions:callOptions
             responseClass:[EndorserResponse class]];
}

@end
#endif
