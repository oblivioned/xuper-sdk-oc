source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '8.0'
install! 'cocoapods', :deterministic_uuids => false

target 'xuper-sdk-oc-iOS' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for xuper-sdk-oc-iOS
  pod 'xuper-sdk-oc-grpc', :path => "./Podspec"
  pod 'OpenSSL-Universal/Framework', '~> 1.0.2.19'

  target 'xuper-sdk-oc-iOSTests' do
    # Pods for testing
    pod 'xuper-sdk-oc-grpc', :path => "./Podspec"
    pod 'OpenSSL-Universal/Framework', '~> 1.0.2.19'
  end

end
