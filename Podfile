platform :ios, ‘8.0’

use_frameworks!

target ‘UniPlus’ do
pod 'PopupDialog', :git => 'https://github.com/Orderella/PopupDialog.git', :tag => '0.4.0'
pod 'PureLayout'
pod 'SwiftMessages'
pod 'CarbonKit'
pod ‘GKFadeNavigationController’

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['SWIFT_VERSION'] = ‘3.0’
        end
    end
end
end
