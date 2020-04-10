# Uncomment this line to define a global platform for your project
platform :ios, '9.0'

use_frameworks!

target "XenPlux" do
#	pod 'Metawear-iOSAPI'
	pod 'MBProgressHUD'
	pod 'Bolts'
	pod 'AWSCore'
	pod 'AWSS3'
    pod 'Alamofire', '~> 4.0'
    pod 'Toast-Swift', :git => 'https://github.com/scalessec/Toast-Swift.git'
#    pod 'SwiftChart', '~> 0.3.0'
    pod 'IQKeyboardManagerSwift', '5.0.0'
    pod 'Fabric', '~> 1.9.0'
    pod 'Crashlytics', '~> 3.12.0'
    pod 'FontAwesome.swift'
    pod 'Charts'
    pod 'OneSignal', '>= 2.6.2', '< 3.0'
    pod 'GaugeKit', :git => 'https://github.com/mark2b/GaugeKit.git'
    pod 'FSCalendar'
    pod 'Firebase/Core'

end

target 'OneSignalNotificationServiceExtension' do
    pod 'OneSignal', '>= 2.6.2', '< 3.0'
end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        if target.name == 'GaugeKit'
            target.build_configurations.each do |config|
                config.build_settings['SWIFT_VERSION'] = '3.0'
            end
        end

    end
end
