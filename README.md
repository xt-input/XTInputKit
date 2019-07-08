# XTInputKit

[![CI Status](https://img.shields.io/travis/xt-input/XTInputKit.svg?style=flat)](https://travis-ci.org/xt-input/XTInputKit)
[![Version](https://img.shields.io/cocoapods/v/XTInputKit.svg?style=flat)](https://cocoapods.org/pods/XTInputKit)
[![License](https://img.shields.io/cocoapods/l/XTInputKit.svg?style=flat)](https://cocoapods.org/pods/XTInputKit)
[![Platform](https://img.shields.io/cocoapods/p/XTInputKit.svg?style=flat)](https://cocoapods.org/pods/XTInputKit)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

XTInputKit is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'XTInputKit'
```

## Author

xt-input, input@tcoding.cn


XTInputKit是一套swift版的代码集，由四部分组成

- [Extension](#Extension)
- [XTITool](#XTITool)
- [XTILoger](#XTILoger)
- [XTINetWork](#XTINetwork)

# Extension
[Extension](doc/Extension.md)是系统提供的常用类的功能扩展集。(文档不完整，请看源码)

# XTITool
[XTITool](doc/XTITool.md)是个工具类集，包括单例协议(`XTISharedProtocol`)、钥匙串工具(`XTIKeyChainTool`)、常用的常量管理工具(`XTIMacros`)、观察者工具(`XTIObserver`)、计时器工具(`XTITimer`)、其它杂项工具(`XTITool`)。(文档不完整，请看源码)

# XTILoger
[XTILoger](doc/XTILoger.md)参考[Loggerithm](https://github.com/honghaoz/Loggerithm) 感谢[honghaoz](https://github.com/honghaoz)，是个打印日志工具，在debug模式下会在终端窗口打印，release模式下返回构造的好的日志。可以将其保存在指定的文件并上传到自己的服务器做数据分析。

# XTINetWork
[XTINetWork](doc/XTINetWork.md)是一个网络请求的封装，依赖[Alamofire](https://github.com/Alamofire/Alamofire)和[XTIObjectMapper](https://github.com/xt-input/XTIObjectMapper)(基于ObjectMapper，进行部分功能扩展)。它较方便的就可以发出网络请求并将返回的json数据处理成定义好的模型。

## 最后

> 文档更新会比较慢，最新修改请查看源码

有些功能扩展没有写上来，代码里有部分注释，请参考注释。

还有一些其他开发笔记之类的可以到我的博客上查看：[小唐朝的blog](http://blog.tcoding.cn)



## License

XTInputKit is available under the MIT license. See the LICENSE file for more info.
