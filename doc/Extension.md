#Extension

> 文档更新会比较慢，最新修改请查看源码

##UIKit

### UINavigationController

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

### UIViewController

> 隐藏导航栏和禁用右划返回参考[FDFullscreenPopGesture](https://github.com/forkingdog/FDFullscreenPopGesture)
>
> 禁用右划返回仅仅在`xti_openBackGesture`开启的时候才会生效
>
> 扩展功能：
>
> 1. 设置导航栏左右两边按钮<仅支持添加一个>，如果不带`action`参数，点击的回调则是`xti_toucheLeftBarButtonItem`或`xti_toucheRightBarButtonItem`
>
> xti_setBarButtonItem(_:title:img:titleColor:action:)
>
> 2. 跳转到其它控制器，根据当前控制器的跳转模式(push、present)自动选择跳转模式，动画参数默认是true
>
> xti_pushOrPresentVC(_:animated:)
>
> 3. 关闭当前控制器，和跳转其它控制器方法对应，动画参数默认是true，`completion`参数默认为nil
>
> xti_popOrDismiss(_:completion:)
>
> 4. 通过StoryBoard初始化控制器，该方法如果不传`withIdentifier`默认使用控制器类名，也就是说如果在StoryBoard里面将控制器的StoryBoard ID设置成类名就只要StoryBoard文件名一个参数就可以了
>
> initwithstoryboard(_:withIdentifier:)
>
> 5. 设置展示在下一级界面导航栏返回按钮的文案和颜色，系统默认是显示该控制器的标题，颜色是蓝色
>
> xti_nextBackTitle、xti_nextBackColor
>
> 6. 设置不同的tabbar标题和navigation标题
>
> xti_tabbarTitle、xti_navigationTitle
>
> 7. 设置导航栏背景色，不支持透明通道，每一个控制器都可以设定不一样的颜色
>
> xti_navigationBarBackgroundColor

使用方法：

```swift
self.xti_navigationTitle = "navigation标题"    //设置导航栏标题，当导航栏标题和标签栏标题的不一致时使用
self.xti_setBarButtonItem(.right, title: "测试")//通过`title`设置导航栏右边的按钮,也可以通过图片设置
self.xti_nextBackTitle = "返回"        //设置下一级控制器的导航栏返回按钮的文案
self.xti_nextBackColor = UIColor.red    //设置下一级控制器的导航栏返回按钮的颜色
self.xti_navigationBarHidden = true    //隐藏导航栏
self.xti_disabledBackGesture = true    //禁用右划返回手势
self.xti_tabbarTitle = "tabbar标题"    //设置标签栏标题，当导航栏标题和标签栏标题的不一致时使用

//通过Storyboard名字初始化控制器，并使用xti_pushOrPresentVC跳转
self.xti_pushOrPresentVC(ViewController.initwithstoryboard("Storyboard"))
//关闭当前控制器
self.xti_popOrDismiss()
//设置导航栏背景颜色
self.xti_navigationBarBackgroundColor = UIColor.red
```

### UITabBarController

> 扩展一个直接添加addChildViewController的方法
>
> 将选中图片、默认图片、标签的标题、控制器做参数传递
>
> xti_addChildViewController(_:tabbarTitle:image:selectedImage)



