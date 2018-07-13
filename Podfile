platform :ios, '11.2'

target 'Syndra' do
  use_frameworks!
  inhibit_all_warnings!

  pod 'Neon'
  pod 'SuperDelegate'
  pod 'SwiftyJSON'
  pod 'NVActivityIndicatorView'
  pod 'MMDrawerController'
  pod 'ChameleonFramework/Swift', :git => 'https://github.com/ViccAlexander/Chameleon.git', :branch => 'wip/swift4'
  pod 'FontBlaster'
  pod 'Parse'
  pod 'SwiftDate', '~> 4.0'
  pod 'TableFlip'
  pod 'PMSuperButton'
  pod 'SCLAlertView'
  pod 'Toucan'
  pod 'AppVersionMonitor'
  pod 'SwiftyUserDefaults'
  pod 'GCDKit', :git => 'https://github.com/JohnEstropia/GCDKit', :branch => 'swift3_develop'
  pod 'StepProgressView'
  pod 'RetroProgress'

  post_install do |installer|
    installer.pods_project.targets.each do |t|

      # Swift 3 Support
      if ['Toucan', 'NVActivityIndicatorView', 'SwiftyJSON', 'SuperDelegate', 'TableFlip', 'GCDKit'].include? t.name
        t.build_configurations.each do |config|
          config.build_settings['SWIFT_VERSION'] = '3'
        end
      end

      # Swift 4.0 support
      if ['RetroProgress', 'StepProgressView', 'SCLAlertView', 'PMSuperButton'].include? t.name
        t.build_configurations.each do |config|
          config.build_settings['SWIFT_VERSION'] = '4.0'
        end
      end
    end
  end

end
