Pod::Spec.new do |s|
  s.name         = "XTInputKit"
  s.version      = "0.0.7"
  s.summary      = "一些常用的iOS开发代码及扩展集合，例如打印日志的工具XTILoger，用16进制取颜色，keychain，NetWork···"
  s.description  = <<-DESC
                    平时开发积累的代码整合起来的。包括且不限于UINavigationController、UIViewController、UITabBarController的扩展，以及String、Date、DispatchQueue的扩展。
                   DESC
  s.homepage     = "https://github.com/xt-input/XTInputKit"
  s.license      = "MIT"
  s.authors      = {"xt-input" => "input@07coding.com"}
  s.platform     = :ios, "9.0"
  s.source       = { :git => "https://github.com/xt-input/XTInputKit.git",
                     :tag => s.version }

  s.subspec 'XTILoger' do |ss|
  ss.source_files = 'Source/XTILoger/*.swift'
  ss.pod_target_xcconfig = { 'SWIFT_VERSION' => '4.1'}
  end

  s.subspec 'Extension' do |ss|
  ss.source_files = 'Source/Extension/**/*.swift'
  ss.pod_target_xcconfig = { 'SWIFT_VERSION' => '4.1'}
  end

  s.subspec 'XTITool' do |ss|
  ss.source_files = 'Source/Class/*.swift'
  ss.pod_target_xcconfig = { 'SWIFT_VERSION' => '4.1'}
  end

  s.subspec 'XTINetWork' do |ss|
  ss.source_files = 'Source/Network/*.swift'
  ss.pod_target_xcconfig = { 'SWIFT_VERSION' => '4.1'}
  ss.dependency 'XTInputKit/XTILoger'
  ss.dependency 'XTInputKit/XTITool'
  ss.dependency 'HandyJSON', '~> 4.1.1'
  ss.dependency 'Alamofire', '~> 4.7.2'
  end

  s.requires_arc  = true
end
