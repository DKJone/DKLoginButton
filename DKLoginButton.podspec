

Pod::Spec.new do |s|

  s.name         = "DKLoginButton"
  s.version      = "4.2.0"
  s.summary      = "A login button with Cool animation and easy to use ."
  s.homepage     = "https://github.com/DKJone/DKLoginButton"
  s.license      = "MIT"
  s.author       = { "DKJone" => "https://github.com/DKJone" }
  s.platform     = :ios, "9.0"
  s.ios.deployment_target = "9.0"
  s.source       = {:git => "https://github.com/DKJone/DKLoginButton.git",:tag => "#{s.version}" }
  s.source_files = "loginbutton/DKButton/*.{swift}"
  s.frameworks   = "UIKit","Foundation"

end
