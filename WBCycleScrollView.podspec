#
# Be sure to run `pod lib lint WBCycleScrollView.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'WBCycleScrollView'
  s.version          = '0.1.0'
  s.summary          = '图片无限轮播视图，支持cell自定义大小，间距'
  s.homepage         = 'https://github.com/wenmobo/WBCycleScrollView'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'wenmobo' => 'wenmobo2018@gmail.com' }
  s.source           = { :git => 'https://github.com/wenmobo/WBCycleScrollView.git', :tag => s.version.to_s }
  s.ios.deployment_target = '8.0'
  s.requires_arc = true

  s.source_files = 'WBCycleScrollView/**/*'
  
  s.frameworks = 'UIKit'
  s.dependency 'SDWebImage', '>= 5.0.0'
end
