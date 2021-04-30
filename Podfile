

platform :ios, '14.0'

# Define the SciChart cocoapods source
source 'https://github.com/ABTSoftware/PodSpecs.git'
source 'https://github.com/CocoaPods/Specs.git'

use_frameworks!
inhibit_all_warnings!

def common_pods
  pod 'SwiftLint'
  pod 'Firebase/Crashlytics'
  pod 'Firebase/Analytics'
#  pod 'SciChart'
#  pod 'SciChart', '4.0.0.5436'
end

def common_test_pods
end


target 'SOLTEC•Z' do
  common_pods
#  pod "Macaw", "0.9.7"
end

target 'SOLTEC•Lab' do
  common_pods
end

target 'SOLTECTests' do
#  common_pods
end


# Copy acknowledgements to settings bundle
post_install do | installer |
  require 'fileutils'
  FileUtils.cp_r('Pods/Target Support Files/Pods-SOLTEC•Z/Pods-SOLTEC•Z-acknowledgements.plist', 'SOLTEC/Resource/Settings.bundle/Acknowledgements.plist', :remove_destination => true)

  # Clean up warning for certain dependencies still targeting deprecated iOS 8.0
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings.delete 'IPHONEOS_DEPLOYMENT_TARGET'
    end
  end
end
