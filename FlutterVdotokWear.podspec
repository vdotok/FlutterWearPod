#
#  Be sure to run `pod spec lint FlutterVdotokWear.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see https://guides.cocoapods.org/syntax/podspec.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |spec|
  spec.name         = "FlutterVdotokWear"
  spec.version      = "0.0.4"
  spec.summary      = "FlutterVdotokWear allows to get all type of sensory data."
  spec.description  = <<-DESC
  Hi, This is pod for wear to get all sensors data and send data to Mobile application.
                   DESC
  spec.homepage     = "https://github.com/vdotok/FlutterWearPod"
  spec.license      = { :type => "MIT", :file => "LICENSE" }
  spec.author             = { "Muhammad Taimoor khan" => "488taimoor@gmail.com" }
  spec.swift_version = "4.2"
  spec.platform     = :watchOS
  spec.platform     = :ios, "9.0"

  spec.source       = { :git => "https://github.com/vdotok/FlutterWearPod.git", :tag => "#{spec.version}" }
  spec.ios.deployment_target = '10.0'
  spec.ios.source_files = "FlutterWearPod/Shared/**/*.swift"
  spec.watchos.deployment_target = '6.0'
  spec.watchos.source_files = "FlutterVdotokWear/WatchOS/**/*.swift"
end
