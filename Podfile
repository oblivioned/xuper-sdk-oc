# Uncomment the next line to define a global platform for your project
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '8.0'
install! 'cocoapods', :deterministic_uuids => false

use_frameworks! if ENV['FRAMEWORKS'] != 'NO'

target 'xuper-sdk-oc' do
  # Comment the next line if you don't want to use dynamic frameworks
  # use_frameworks!

  # Pods for xuper-sdk-oc
  pod 'xuper-sdk-oc-grpc', :path => "./Podspec"

  target 'xuper-sdk-ocTests' do
    # Pods for testing
    pod 'xuper-sdk-oc-grpc', :path => "./Podspec"
  end

end
