Pod::Spec.new do |s|
  s.name     = 'xuper-sdk-oc-grpc'
  s.version  = '0.0.1'
  s.license  = '...'
  s.authors  = { 'oblivioned' => '371397938@qq.com' }
  s.homepage = '...'
  s.summary = '...'
  s.source = { :git => 'https://github.com/' }

  s.ios.deployment_target = '8.0'

  # Base directory where the .proto files are.
  src = '../xuper-pb'

  # We'll use protoc with the gRPC plugin.
  s.dependency '!ProtoCompiler-gRPCPlugin', '~> 1.0'

  # Pods directory corresponding to this app's Podfile, relative to the location of this podspec.
  pods_root = "../Pods"

  # Path where Cocoapods downloads protoc and the gRPC plugin.
  protoc_dir = "#{pods_root}/\!ProtoCompiler"
  protoc = "#{protoc_dir}/protoc"
  plugin = "#{pods_root}/\!ProtoCompiler-gRPCPlugin/grpc_objective_c_plugin"

  # Directory where you want the generated files to be placed. This is an example.
  obj_output_dir = "../xuper-sdk-oc/XProvider/Message"
  services_output_dir = "../xuper-sdk-oc/XProvider/Services"

  # Run protoc with the Objective-C and gRPC plugins to generate protocol messages and gRPC clients.
  # You can run this command manually if you later change your protos and need to regenerate.
  # Alternatively, you can advance the version of this podspec and run `pod update`.
  s.prepare_command = <<-CMD

    mkdir -p #{obj_output_dir}
    mkdir -p #{services_output_dir}

    #{protoc} \
        --plugin=protoc-gen-grpc=#{plugin} \
        --objc_out=#{obj_output_dir} \
        --grpc_out=#{services_output_dir} \
        -I #{src} \
        #{src}/*.proto
  CMD

  s.pod_target_xcconfig = {
    # This is needed by all pods that depend on Protobuf:
    'GCC_PREPROCESSOR_DEFINITIONS' => '$(inherited) GPB_USE_PROTOBUF_FRAMEWORK_IMPORTS=1',
    # This is needed by all pods that depend on gRPC-RxLibrary:
    'CLANG_ALLOW_NON_MODULAR_INCLUDES_IN_FRAMEWORK_MODULES' => 'YES',
  }

end
