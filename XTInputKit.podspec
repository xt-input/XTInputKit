Pod::Spec.new do |s|
  s.name         = "XTInputKit"
  s.version      = "0.0.3"
  s.summary      = "一些常用的iOS开发代码及扩展集合"
  s.description  = <<-DESC
                    平时开发积累的代码整合起来的。
                   DESC
  s.homepage     = "https://github.com/xt-input/XTInputKit"
  s.license      = "MIT"
  s.authors      = {"input" => "input@07coding.com"}
  s.platform     = :ios, "9.0"
  s.source       = { :git => "https://github.com/xt-input/XTInputKit.git",
                     :tag => s.version }

  s.source_files = 'Source/XTInputKit-ObjC.h'

  s.subspec 'ObjC' do |ss|
  ss.source_files = 'Source/ObjC/*.{h,m}'
  end

  s.subspec 'XTILoger' do |ss|
  ss.source_files = 'Source/XTILoger/*.swift'
  ss.pod_target_xcconfig = { 'SWIFT_VERSION' => '4.0'}
  end

  s.subspec 'SWIFT' do |ss|
  ss.source_files = 'Source/{Class,Extension}/**/*.swift'
  ss.pod_target_xcconfig = { 'SWIFT_VERSION' => '4.0'}
  ss.dependency 'XTInputKit/ObjC'
  end

  s.requires_arc  = true
end
