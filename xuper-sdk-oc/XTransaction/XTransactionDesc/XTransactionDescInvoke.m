//
//  XTransactionDescContracts.m
//  xuper-sdk-oc-iOS
//
//  Created by apple on 2019/12/7.
//  Copyright © 2019 Martin.Ren. All rights reserved.
//

#import "XTransactionDescInvoke.h"

XContractNameStandardModuleName const _Nonnull XContractNameStandardModuleNameKernel = @"xkernel";

@implementation XTransactionDescInvoke

- (NSMutableDictionary *)encodeArgsToDictionaryWithError:(NSError **)error {
    
    if ( self.args && self.args.count > 0 ) {
            
        NSMutableDictionary *jargs = [[NSMutableDictionary alloc] init];
        
        for ( NSString *key in self.args.allKeys ) {
            
            id value = self.args[key];
            
            if ( [value respondsToSelector:@selector(encodeToJsonObjectWithError:)] ) {
                
                id jvalue = [value encodeToJsonObjectWithError:error];
                
                if (error) {
                    return nil;
                } else {
                    jargs[key] = jvalue;
                }
                
            } else {
                jargs[key] = value;
            }
        }
        
        return jargs;
        
    } else {
        return nil;
    }
}

- (NSData * _Nonnull)encodeToDataWithError:(NSError * _Nonnull * _Nullable)error {
    
    NSMutableDictionary *jobject = [[NSMutableDictionary alloc] init];
    
    if ( !self.moduleName || self.moduleName.length <= 0 ) {
        ///在没有填写modulename 的情况下使用 xkernel
        jobject[@"module_name"] = XContractNameStandardModuleNameKernel;
    } else {
        jobject[@"module_name"] = self.moduleName;
    }
    
    if ( self.contractName && self.contractName.length > 0 ) {
        jobject[@"contract_name"] = self.contractName;
    }
    
    if ( self.methodName && self.methodName.length > 0 ) {
        jobject[@"method_name"] = self.methodName;
    }
    
    NSMutableDictionary *jargs = [self encodeArgsToDictionaryWithError:error];
    if (error) {
        return nil;
    }
    if (jargs) {
        jobject[@"args"] = jargs;
    }
    
    NSData *jobjData = [NSJSONSerialization dataWithJSONObject:jobject options:NSJSONWritingSortedKeys error:error];
    if (error) {
        return nil;
    }
    
    return jobjData;
}

- (NSData * _Nonnull)encodeToData {
    return [self encodeToDataWithError:nil];
}

- (InvokeRequest * _Nonnull)invokeRequest {
    
    InvokeRequest *request = InvokeRequest.message;
    
    request.moduleName = self.moduleName;
    request.contractName = self.contractName;
    request.methodName = self.methodName;
    
    if ( self.args && self.args.count > 0 ) {
        
        for ( NSString *key in self.args.allKeys ) {
            
            id value = self.args[key];
            
            if ( [value respondsToSelector:@selector(encodeToJsonObjectWithError:)] ) {
                
                id encdoedValue = [value encodeToJsonObjectWithError:nil];
                
                if ( encdoedValue && [encdoedValue isKindOfClass:[NSDate class]] ) {
                    
                    request.args[key] = encdoedValue;
                    
                } else if ( encdoedValue && [encdoedValue isKindOfClass:[NSString class]] ) {
                    
                    NSData *encdoedValueData = [NSJSONSerialization dataWithJSONObject:encdoedValue options:NSJSONWritingSortedKeys error:nil];
                    if (encdoedValueData) {
                        request.args[key] = encdoedValueData;
                    }
                    
                } else if ( encdoedValue && ([encdoedValue isKindOfClass:[NSArray class]] || [encdoedValue isKindOfClass:[NSDictionary class]])) {
                    
                    NSData *encdoedValueData = [NSJSONSerialization dataWithJSONObject:encdoedValue options:NSJSONWritingSortedKeys error:nil];
                    if (encdoedValueData) {
                        request.args[key] = encdoedValueData;
                    }
                }
                
            } else {
                
                if ( value && [value isKindOfClass:[NSDate class]] ) {
                    
                    request.args[key] = value;
                    
                } else if ( value && [value isKindOfClass:[NSString class]] ) {
                    
                    request.args[key] = [((NSString*)value) dataUsingEncoding:NSUTF8StringEncoding];
                    
                } else if ( value && ([value isKindOfClass:[NSArray class]] || [value isKindOfClass:[NSDictionary class]])) {
                    
                    NSData *jvalueData = [NSJSONSerialization dataWithJSONObject:value options:NSJSONWritingSortedKeys error:nil];
                    if (jvalueData) {
                        request.args[key] = jvalueData;
                    }
                    
                }
            }
        }
    }
    
    return request;
}

@end
