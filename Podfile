platform :ios, '11.2'

target 'Syndra' do
  use_frameworks!
  inhibit_all_warnings!

  # From Git
    pod 'GCDKit', :git => 'https://github.com/JohnEstropia/GCDKit', :branch => 'swift3_develop'
    pod 'ChameleonFramework/Swift', :git => 'https://github.com/ViccAlexander/Chameleon.git', :branch => 'wip/swift4'

  # System
    pod 'SwiftyJSON'
    pod 'Parse'
    pod 'Fabric'
    pod 'Crashlytics'
    pod 'Parse/UI'
    pod 'SwiftDate', '~> 4.0'
    pod 'AppVersionMonitor'
    pod 'SwiftyUserDefaults'
    pod 'arek'

  # UI/Layout
    pod 'Neon'
    pod 'McPicker'
    pod 'NVActivityIndicatorView'
    pod 'MMDrawerController'
    pod 'FontBlaster'
    pod 'Spring'
    pod 'TableFlip'
    pod 'PMSuperButton'
    pod 'SCLAlertView'
    pod 'Toucan'
    pod 'StepProgressView'
    pod 'RetroProgress'

  # Misc
    pod 'EAIntroView'

  post_install do |installer|
    installer.pods_project.targets.each do |t|

      # Swift 3 Support
      if ['ParseUI', 'Toucan', 'NVActivityIndicatorView', 'SwiftyJSON', 'SuperDelegate', 'TableFlip', 'GCDKit'].include? t.name
        t.build_configurations.each do |config|
          config.build_settings['SWIFT_VERSION'] = '3'
        end
      end

      # Swift 4.0 support
      if ['McPicker', 'arek', 'PMAlertController', 'Spring', 'RetroProgress', 'StepProgressView', 'SCLAlertView', 'PMSuperButton'].include? t.name
        t.build_configurations.each do |config|
          config.build_settings['SWIFT_VERSION'] = '4.0'
        end
      end
    end
  end

end
