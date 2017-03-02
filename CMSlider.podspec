Pod::Spec.new do |s|
  s.name         = "CMSlider"
  s.version      = "0.0.1"
  s.summary      = "A collection of draggable controls."
  s.description  = <<-DESC
  A collection of draggable controls, have fun.
                   DESC
  s.homepage     = "https://github.com/chucklab/CMSlider"
  s.license      = { :type => 'MIT', :file => 'LICENSE' }
  s.author             = { "Chuck MA" => "chuck@chucklab.com" }
  s.platform     = :ios, '6.0'
  s.ios.deployment_target = '6.0'
  s.source       = { :git => "https://github.com/chucklab/CMSlider.git", :tag => "#{s.version}" }
  s.source_files  = "Classes"
  s.exclude_files = "Classes/Exclude"
  s.public_header_files = "Classes/*.h"
  s.frameworks = "Foundation", "UIKit"
  s.requires_arc = true
end

