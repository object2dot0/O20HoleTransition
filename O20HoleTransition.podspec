#
# Be sure to run `pod lib lint O20HoleTransition.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'O20HoleTransition'
  s.version          = '0.1.0'
    s.author       = 'Tanveer'
  s.summary          = 'Custom UIViewController transition to present the UIViewController.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
A custom UIViewController transition to show the ViewController with the closing and opening hole.
* More suited towards the loading screens as while the transiting is happening user will see the preview of the screen underneath it.

                       DESC

  s.homepage         = 'https://github.com/object2dot0/O20HoleTransition'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Tanveer' => 'object2.0@gmail.com' }
  s.source           = { :git => 'https://github.com/object2dot0/O20HoleTransition.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/object2dot0'

  s.ios.deployment_target = '8.0'

  s.source_files = 'O20HoleTransition/Classes/**/*'
  
  # s.resource_bundles = {
  #   'O20HoleTransition' => ['O20HoleTransition/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
   s.frameworks = 'UIKit', 'QuartzCore'
  # s.dependency 'AFNetworking', '~> 2.3'
end
