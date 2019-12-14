Pod::Spec.new do |s|
  s.name     = 'xuper-sdk-oc'
  s.version  = '0.0.1'
  s.license  = { :type => 'Apache License Version 2.0', :file => 'LICENSE' }
  s.authors  = { 'oblivioned' => '...' }
  s.homepage = 'https://github.com/oblivioned/xuper-sdk-oc'
  s.summary = 'xuper-sdk-oc for iOS and macOS'
  s.source = { :git => 'https://github.com/oblivioned/xuper-sdk-oc.git', :tag => 'v0.0.1' }

  s.ios.deployment_target = '8.0'
  s.osx.deployment_target = '10.9'
  # s.tvos.deployment_target = '10.0'
  # s.watchos.deployment_target = '4.0'

  s.dependency '!ProtoCompiler-gRPCPlugin', '~> 1.0'
  s.dependency 'OpenSSL-Universal/Framework', '~> 1.0.2.19'

  s.xcconfig = {
      'GCC_PREPROCESSOR_DEFINITIONS' => '$(inherited) GPB_USE_PROTOBUF_FRAMEWORK_IMPORTS=1'
  }

  s.source_files =  "xuper-sdk-oc/XBigInt/*.{h,m}",
                    "xuper-sdk-oc/XCategory/*.{h,m}",
                    "xuper-sdk-oc/XCommon/*.{h,m}",
                    "xuper-sdk-oc/XClient/*.{h,m}",
                    "xuper-sdk-oc/XClient/XClientGRPC/*.{h,m}",
                    "xuper-sdk-oc/XCrypto/*.{h,m}",
                    "xuper-sdk-oc/XCrypto/ECDSA/*.{h,m}",
                    "xuper-sdk-oc/XCrypto/Protocol/*.{h,m}",
                    "xuper-sdk-oc/XCrypto/Protocol/KeyPair/*.{h,m}",
                    "xuper-sdk-oc/XProvider/*.{h,m}",
                    "xuper-sdk-oc/XProvider/Message/*.{h,m}",
                    "xuper-sdk-oc/XProvider/Message/MessageCategory/*.{h,m}",
                    "xuper-sdk-oc/XProvider/Services/*.{h,m}",
                    "xuper-sdk-oc/XTransaction/*.{h,m}",
                    "xuper-sdk-oc/XTransaction/XTransactionBuilder/*.{h,m}",
                    "xuper-sdk-oc/XTransaction/XTransactionDesc/*.{h,m}",
                    "xuper-sdk-oc/XTransaction/XTransactionOpt/*.{h,m}",
                    "xuper-sdk-oc/XTransaction/XTransactionOpt/Category/*.{h,m}",
                    "xuper-sdk-oc/XuperClient/*.{h,m}",
                    "xuper-sdk-oc/XuperClient/Services/*.{h,m}"

  s.public_header_files = "xuper-sdk-oc/XBigInt/*.h",
                          "xuper-sdk-oc/XCategory/*.h",
                          "xuper-sdk-oc/XCommon/*.h",
                          "xuper-sdk-oc/XClient/*.h",
                          "xuper-sdk-oc/XClient/XClientGRPC/*.h",
                          "xuper-sdk-oc/XCrypto/*.h",
                          "xuper-sdk-oc/XCrypto/ECDSA/*.h",
                          "xuper-sdk-oc/XCrypto/Protocol/*.h",
                          "xuper-sdk-oc/XCrypto/Protocol/KeyPair/*.h",
                          "xuper-sdk-oc/XProvider/*.h",
                          "xuper-sdk-oc/XProvider/Message/*.h",
                          "xuper-sdk-oc/XProvider/Message/MessageCategory/*.h",
                          "xuper-sdk-oc/XProvider/Services/*.h",
                          "xuper-sdk-oc/XTransaction/*.h",
                          "xuper-sdk-oc/XTransaction/XTransactionBuilder/*.h",
                          "xuper-sdk-oc/XTransaction/XTransactionDesc/*.h",
                          "xuper-sdk-oc/XTransaction/XTransactionOpt/*.h",
                          "xuper-sdk-oc/XTransaction/XTransactionOpt/Category/*.h",
                          "xuper-sdk-oc/XuperClient/*.h",
                          "xuper-sdk-oc/XuperClient/Services/*.h"

  #grpc 插件生产的文件不支持arc，需要剔除
  s.requires_arc = false
  s.requires_arc = "xuper-sdk-oc/XBigInt/*.{h,m}",
                   "xuper-sdk-oc/XCategory/*.{h,m}",
                   "xuper-sdk-oc/XCommon/*.{h,m}",
                   "xuper-sdk-oc/XClient/*.{h,m}",
                   "xuper-sdk-oc/XClient/XClientGRPC/*.{h,m}",
                   "xuper-sdk-oc/XCrypto/*.{h,m}",
                   "xuper-sdk-oc/XCrypto/ECDSA/*.{h,m}",
                   "xuper-sdk-oc/XCrypto/Protocol/*.{h,m}",
                   "xuper-sdk-oc/XCrypto/Protocol/KeyPair/*.{h,m}",
                   "xuper-sdk-oc/XProvider/*.{h,m}",
                   "xuper-sdk-oc/XProvider/Message/MessageCategory/*.{h,m}",
                   "xuper-sdk-oc/XTransaction/*.{h,m}",
                   "xuper-sdk-oc/XTransaction/XTransactionBuilder/*.{h,m}",
                   "xuper-sdk-oc/XTransaction/XTransactionDesc/*.{h,m}",
                   "xuper-sdk-oc/XTransaction/XTransactionOpt/*.{h,m}",
                   "xuper-sdk-oc/XuperClient/*.{h,m}",
                   "xuper-sdk-oc/XuperClient/Services/*.{h,m}"
end
