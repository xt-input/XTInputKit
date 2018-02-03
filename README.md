# XTInputKit

XTInputKit是一套swift版的代码集，暂时有：

- [XTILoger](#xtiloger)
- [XTIMacros](#xtimacros)
- [XTITool](#xtitool)
- [UINavigationController](#uinavigationcontroller)
- [UIViewController](#uiviewcontroller)
- [UITabBarController](#uitabbarcontroller)

## XTILoger

> 来自：[Loggerithm](https://github.com/honghaoz/Loggerithm) 感谢[honghaoz](https://github.com/honghaoz)

> 打印日志工具，在debug模式下会在终端窗口打印，release模式下返回构造的好的日志，可以将其保存在指定的文件上传到自己的服务器做数据分析

示例：

```swift
  var log = XTILoger.default	//如果需要修改默认的日志等级不要直接使用XTLoger.default
  log.debugLogLevel = .debug	//debug模式的日志等级
  log.releaseLogLevel = .warning	//release模式的日志等级，在release模式下只会构造日志不会打印在控制台，可以自己保存到本地
  log.info(format: "%@%@", args: self, self)
  log.debug(format: "%@%@", args: self, self)
  log.warning(format: "%@%@", args: self, self)
  log.error(format: "%@%@", args: self, self)

  XTILoger.default.info(1231)
  XTILoger.default.debug(1231)
  XTILoger.default.warning(1231)
  XTILoger.default.error(1231)
```

>后续会加入写入本地文件的功能

## XTIMacros

> 整合一些常用的值，例如:
>
> ​	取屏幕宽度：XTMacros.SCREEN_WIDTH
>
> ​	取屏幕高度：XTMacros.SCREEN_HEIGHT
>
> ​	判断是否是iPhone x：XTMacros.isIphoneX
>
> ···等等的

## XTITool

> 获取rootVC、currentVC、keyWindow

```swift
XTITool.keyWindow.rootViewController = ViewController()	//修改根控制器
XTITool.currentVC.xti_pushOrPresentVC(ViewController())	//从当前活动的控制器调转到ViewController，如果当前控制器在navigetionVC上那么久push，否则present
```

## UINavigationController

> 这部分的扩展来自：[FDFullscreenPopGesture](https://github.com/forkingdog/FDFullscreenPopGesture) 感谢[forkingdog](https://github.com/forkingdog)

> 加入全屏滑动返回
>
> 有两个开关，一个是全局设置开关，需要在应用第一个UINavigationController对象初始化之前设置。
>
> 另一个是针对单个UINavigationController的，该开关优先级大于全局开关

使用方法：

```swift
在application(_:didFinishLaunchingWithOptions:)函数里： 
UINavigationController.xti_openBackGesture = false

在项目UINavigationController封装的基类里：
override func xti_openBackGesture() -> Bool {
  return ture
}
```
## UIViewController

> 隐藏导航栏和禁用右划返回参考[FDFullscreenPopGesture](https://github.com/forkingdog/FDFullscreenPopGesture)
>
> 禁用右划返回仅仅在`xti_openBackGesture`开启的时候才会生效
>
> 扩展功能：
>
> 1. 设置导航栏左右两边按钮<仅支持添加一个>，如果不带`action`参数，点击的回调则是`xti_toucheLeftBarButtonItem`或`xti_toucheRightBarButtonItem`
>
>    xti_setBarButtonItem(_:title:img:titleColor:action:)
>
> 2. 跳转到其它控制器，根据当前控制器的跳转模式(push、present)自动选择跳转模式，动画参数默认是true
>
>    xti_pushOrPresentVC(_:animated:)
>
> 3. 关闭当前控制器，和跳转其它控制器方法对应，动画参数默认是true，`completion`参数默认为nil
>
>    xti_popOrDismiss(_:completion:)
>
> 4. 通过StoryBoard初始化控制器，该方法如果不传`withIdentifier`默认使用控制器类名，也就是说如果在StoryBoard里面将控制器的StoryBoard ID设置成类名就只要StoryBoard文件名一个参数就可以了
>
>    initwithstoryboard(_:withIdentifier:)
>
> 5. 设置展示在下一级界面导航栏返回按钮的文案和颜色，系统默认是显示该控制器的标题，颜色是蓝色
>
>    xti_nextBackTitle、xti_nextBackColor
>
> 6. 设置不同的tabbar标题和navigation标题
>
>    xti_tabbarTitle、xti_navigationTitle
>
> 7. 设置导航栏背景色，不支持透明通道，每一个控制器都可以设定不一样的颜色
>
>    xti_navigationBarBackgroundColor

使用方法：

```swift
self.xti_navigationTitle = "navigation标题"	//设置导航栏标题，当导航栏标题和标签栏标题的不一致时使用
self.xti_setBarButtonItem(.right, title: "测试")//通过`title`设置导航栏右边的按钮,也可以通过图片设置
self.xti_nextBackTitle = "返回"		//设置下一级控制器的导航栏返回按钮的文案
self.xti_nextBackColor = UIColor.red	//设置下一级控制器的导航栏返回按钮的颜色
self.xti_navigationBarHidden = true	//隐藏导航栏
self.xti_disabledBackGesture = true	//禁用右划返回手势
self.xti_tabbarTitle = "tabbar标题"	//设置标签栏标题，当导航栏标题和标签栏标题的不一致时使用

//通过Storyboard名字初始化控制器，并使用xti_pushOrPresentVC跳转
self.xti_pushOrPresentVC(ViewController.initwithstoryboard("Storyboard"))
//关闭当前控制器
self.xti_popOrDismiss()
//设置导航栏背景颜色
self.xti_navigationBarBackgroundColor = UIColor.red
```
## UITabBarController

> 扩展一个直接添加addChildViewController的方法
>
> 将选中图片、默认图片、标签的标题、控制器做参数传递
>
> xti_addChildViewController(_:tabbarTitle:image:selectedImage)

 

## 最后

有些功能扩展没有写上来，代码里有部分注释，请参考注释。

还有一些其他开发笔记之类的可以到我的博客上查看：[小唐朝的blog](http://blog.07coding.com)
