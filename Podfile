# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'app-wd-challenge' do
    # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
    use_frameworks!

    # Pods for app-wd-challenge

    pod 'SwiftyJSON'
    pod 'Alamofire', '~> 4.5'
    pod 'NVActivityIndicatorView'
    pod ‘SDWebImage’
    pod 'SCLAlertView'
    pod "TouchVisualizer", '~>3.0.0'
  
end

post_install do | installer |
    require 'fileutils'
    
    FileUtils.cp_r('Pods/Target Support Files/Pods-app-wd-challenge/Pods-app-wd-challenge-Acknowledgements.plist', 'app-wd-challenge/Settings.bundle/Acknowledgements.plist', :remove_destination => true)
    
end
