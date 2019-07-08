#XTILoger

> 文档更新会比较慢，最新修改请查看源码

## 功能列表

```swift
/// 请在 "Swift Compiler - Custom Flags" 选项查找 "Other Swift Flags" 然后在DEBUG配置那里添加"-D DEBUG".
public class XTILoger : XTISharedProtocol {

    /// 保存到日志文件的等级
    public var saveFileLevel: XTInputKit.XTILogerLevel

    /// 文件名字格式，支持Y(year)、WY(weekOfYear)、M(month)、D(day) 例如，以2018/3/21为例 "Y-WY"=>2018Y-12WY "Y-M-D"=>2018Y-3M-21D "Y-M"=>2018Y-3M，通过这类的组合可以构成一个日志文件保存一天、一周、一个月、一年等方式。建议使用"Y-WY" or "Y-M"，一定要用"-"隔开
    public var fileFormatter: String

    /// 是否打印时间戳
    public var isShowLongTime: Bool

    /// 是否打印日志等级
    public var isShowLevel: Bool

    /// 是否打印线程
    public var isShowThread: Bool

    /// release模式下默认打印日志的等级
    public var releaseLogLevel: XTILogerLevel!

    /// debug模式下默认打印日志的等级
    public var debugLogLevel: XTILogerLevel!

    /// 是否打印文件名
    public var isShowFileName: Bool

    /// 是否打印调用所在的函数名字
    public var isShowFunctionName: Bool

    /// 是否打印调用所在的行数
    public var isShowLineNumber: Bool

    required public init()

    public func info(format: String, function: String = #function, file: String = #file, line: Int = #line, _ args: Any?...) -> String

    public func info(_ value: Any?, function: String = #function, file: String = #file, line: Int = #line) -> String

    public func debug(format: String, function: String = #function, file: String = #file, line: Int = #line, _ args: Any?...) -> String

    public func debug(_ value: Any?, function: String = #function, file: String = #file, line: Int = #line) -> String

    public func warning(format: String, function: String = #function, file: String = #file, line: Int = #line, _ args: Any?...) -> String

    public func warning(_ value: Any?, function: String = #function, file: String = #file, line: Int = #line) -> String

    public func error(format: String, function: String = #function, file: String = #file, line: Int = #line, _ args: Any?...) -> String

    public func error(_ value: Any?, function: String = #function, file: String = #file, line: Int = #line) -> String

    /// 通过日志等级获取当前日志文件的路径
    ///
    /// - Parameter level: 日志等级
    /// - Returns: 文件路径
    public func getCurrentLogFilePath(_ level: XTILogerLevel) -> String

    /// 获取日志文件夹的路径，没有该文件夹就创建
    ///
    /// - Returns: 日志文件夹的路径
    public func getLogDirectory() -> String

    /// 获取所有日志文件的路径
    ///
    /// - Returns: 所有日志文件的路径
    public func getLogFilesPath() -> [String]

    /// 清理日志文件
    ///
    /// - Returns: 操作结果
    public func cleanLogFiles() -> Bool
}
```



用法：

```swift
var log = XTILoger.shared()   //如果需要修改默认的日志等级不要直接使用XTLoger.default
log.debugLogLevel = .debug    //debug模式的日志等级
log.releaseLogLevel = .warning    //release模式的日志等级，在release模式下只会构造日志不会打印在

控制台，可以自己保存到本地
log.info(format: "%@%@", args: self, self)
log.debug(format: "%@%@", args: self, self)
log.warning(format: "%@%@", args: self, self)
log.error(format: "%@%@", args: self, self)

XTILoger.shared().info(1231)
XTILoger.shared().debug(1231)
XTILoger.shared().warning(1231)
XTILoger.shared().error(1231)

var str = "error"
xtiloger.info(str)
xtiloger.info(format: "%d %.2lf %p %.3f %@ %u", 123, 123.0, 12, 123.0, "123", -123)

xtiloger.debug("123123")
xtiloger.warning("123123")
xtiloger.error("123123")

xtiloger.debug(format: "%d %.2lf %p %.3f %@ %u", 123, 123.0, 123, 123.0, "123", -123)
xtiloger.warning(format: "%d %.2lf %p %.3f %@ %u", 123, 123.0, 1231, 123.0, "123", -123)
xtiloger.error(format: "%d %.2lf %p %.3f %@ %u", 123, 123.0, 1233, 123.0, "123", -123)

```

