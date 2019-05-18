#
# Be sure to run `pod lib lint XTInputKit.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'XTInputKit'
  s.version          = '0.2.3'
  s.summary          = '一些常用的iOS开发代码及扩展集合，例如打印日志的工具XTILoger，用16进制取颜色，keychain，NetWork···'
  
  s.description      = <<-DESC
  TODO:平时开发积累的代码整合起来的。包括且不限于UINavigationController、UIViewController、UITabBarController的扩展，以及String、Date、DispatchQueue的扩展。
                       DESC

  s.homepage         = 'https://github.com/xt-input/XTInputKit'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'xt-input' => 'input@tcoding.cn' }
  s.source           = { :git => 'https://github.com/xt-input/XTInputKit.git', :tag => s.version.to_s }

  s.ios.deployment_target = '10.0'
  
  s.subspec 'XTILoger' do |ss|
      ss.source_files = 'XTInputKit/Classes/XTILoger/*.swift'
  end
  
  s.subspec 'Extension' do |ss|
      ss.source_files = 'XTInputKit/Classes/Extension/**/*.swift'
  end
  
  s.subspec 'XTITool' do |ss|
      ss.source_files = 'XTInputKit/Classes/XTIClass/*.swift'
  end
  
  s.subspec 'XTINetWork' do |ss|
    ss.source_files = 'XTInputKit/Classes/Network/*.swift'
    ss.dependency 'XTInputKit/XTILoger'
    ss.dependency 'XTInputKit/XTITool'
    ss.dependency 'HandyJSON', '~> 5.0.0'
    ss.dependency 'Alamofire', '~> 5.0.0-beta.6'
  end
  s.swift_version = '5'
  s.requires_arc  = true
  
  # s.resource_bundles = {
  #   'XTInputKit' => ['XTInputKit/Assets/*.png']
  # }
  
end
