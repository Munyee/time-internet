# Uncomment the next line to define a global platform for your project
source 'https://github.com/CocoaPods/Specs.git'
source 'git@bitbucket.org:apptivitylab/aptpodrepo.git'
platform :ios, '10.0'


target 'TimeSelfCareData' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # ApptivityFramework
  pod 'ApptivityFramework', :path => './ApptivityFramework'
  #pod 'ApptivityFramework', :git => 'git@bitbucket.org:apptivitylab/apptivityframework-ios.git', :branch => 'master'
  
  # Pods for TimeSelfCareData
  pod 'Alamofire'
  pod 'APTSidebarNavigationController'
  pod 'CardIO'
  pod 'SDWebImage'
  pod 'EasyTipView'
  pod 'JVFloatLabeledTextField'

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
  pod 'MBProgressHUD'
  pod 'lottie-ios'
  pod 'Firebase/Core'
  pod 'Crashlytics'

  target 'TimeSelfCareTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'TimeSelfCareUITests' do
    inherit! :search_paths
    # Pods for testing
  end

end
