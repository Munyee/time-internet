# Uncomment the next line to define a global platform for your project
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '10.0'


target 'TimeSelfCareData' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # ApptivityFramework
  pod 'ApptivityFramework', :path => './ApptivityFramework'
  #pod 'ApptivityFramework', :git => 'git@bitbucket.org:apptivitylab/apptivityframework-ios.git', :branch => 'master'
  
  # Pods for TimeSelfCareData
  pod 'Alamofire', '~> 4.7.2'
  pod 'CardIO'
  pod 'SDWebImage'
  pod 'EasyTipView', :git => 'git@10.60.81.57:BSS/EasyTipView.git'
  pod 'JVFloatLabeledTextField'
  pod 'Firebase/Core'
  pod 'Firebase/Crashlytics'
  pod 'Firebase/Performance'

  target 'TimeSelfCareDataTests' do
    inherit! :search_paths
    # Pods for testing
  end

end

target 'TimeSelfCare' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # ApptivityFramework
  pod 'ApptivityFramework', :path => './ApptivityFramework'
  #pod 'ApptivityFramework', :git => 'git@bitbucket.org:apptivitylab/apptivityframework-ios.git', :branch => 'master'

  # Pods for TimeSelfCare
  pod 'SwiftLint'
  pod 'SwiftyJSON'
  pod 'MBProgressHUD', '~> 1.1.0'
  pod 'lottie-ios'
  pod 'Firebase/Core'
  pod 'Firebase/RemoteConfig'
  pod 'Firebase/Crashlytics'
  pod 'FreshchatSDK'
  pod 'Smartlook'
  pod "Pulsator"
  pod 'youtube-ios-player-helper'
  pod 'Firebase/Analytics'
  pod 'Firebase/DynamicLinks'
  pod 'FBSDKCoreKit'
  pod 'Firebase/Performance'
  pod 'IQKeyboardManagerSwift'
  
  target 'TimeSelfCareTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'TimeSelfCareUITests' do
    inherit! :search_paths
    # Pods for testing
  end

end

my_project_pods_swift_versions = Hash[
  "4.0", ["Alamofire", "CardIO", "SDWebImage", "EasyTipView", "JVFloatLabeledTextField", "SwiftLint", "MBProgressHUD", "ApptivityFramework"]
]

def setup_all_swift_versions(target, pods_swift_versions)
  pods_swift_versions.each { |swift_version, pods| setup_swift_version(target, pods, swift_version) }
end

def setup_swift_version(target, pods, swift_version)
  if pods.any? { |pod| target.name.include?(pod) }
    target.build_configurations.each do |config|
      config.build_settings['SWIFT_VERSION'] = swift_version
    end
  end
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    setup_all_swift_versions(target, my_project_pods_swift_versions)
  end
end

pre_install do |installer|
  installer.analysis_result.specifications.each do |s|
    s.swift_version = '4.2'
  end
end
