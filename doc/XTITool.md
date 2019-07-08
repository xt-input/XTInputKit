#XTITool

> 文档更新会比较慢，最新修改请查看源码

## XTIMacros

> 整合一些常用的值，例如:
>
> ​    取屏幕宽度：XTMacros.SCREEN_WIDTH
>
> ​    取屏幕高度：XTMacros.SCREEN_HEIGHT
>
> ​    判断是否是iPhone x：XTMacros.isIphoneX
>
> ···等等的

## XTITool

> 获取rootVC、currentVC、keyWindow
>
> 2018/3/21：添加通过版本号字符串比较版本号的函数

```swift
XTITool.keyWindow.rootViewController = ViewController()    //修改根控制器
XTITool.currentVC.xti_pushOrPresentVC(ViewController())    //从当前活动的控制器调转到ViewController，如果当前控制器在navigetionVC上那么久push，否则present
```

## XTISharedProtocol

> 单例协议，实现该协议即可使用shared() 获取一个单例

