#
# Be sure to run `pod lib lint Swiper.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'Swiper'
  s.version          = '0.0.1'
  s.summary          = 'UIView sublass for creating Tinder like swipe cards.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = 'UIView sublass for creating Tinder like swipe cards, with a peek view.'

  s.homepage         = 'https://github.com/gkye/Swiper'
  s.license          = 'MIT'
  s.author           = { "George Kye" => "qwstnz@gmail.com" }
  s.source           = { :git => 'https://github.com/gkye/Swiper.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/kyegeorge'

  s.ios.deployment_target = '8.0'

  s.source_files = 'Sources/**/*'


  s.frameworks = 'UIKit'
  s.platform     = :ios, "9.0"

  s.dependency 'Stellar'
  s.dependency 'PeekView'
end
