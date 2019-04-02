//
//  XTILoger.swift
//  XTInputKit
//    参考代码：https://github.com/honghaoz/Loggerithm
//    (仿写)
//  Created by Input on 2018/1/3.
//  Copyright © 2018年 Input. All rights reserved.
//

import UIKit

public enum XTILogerLevel: Int {
    public typealias RawValue = Int

    case all = 0
    case info = 1
    case debug = 2
    case warning = 3
    case error = 4
    case off = 5
}

extension XTILogerLevel: Comparable {
    public static func < (lhs: XTILogerLevel, rhs: XTILogerLevel) -> Bool {
        return lhs.rawValue < rhs.rawValue
    }

    public static func <= (lhs: XTILogerLevel, rhs: XTILogerLevel) -> Bool {
        return lhs.rawValue <= rhs.rawValue
    }

    public static func >= (lhs: XTILogerLevel, rhs: XTILogerLevel) -> Bool {
        return lhs.rawValue >= rhs.rawValue
    }

    public static func > (lhs: XTILogerLevel, rhs: XTILogerLevel) -> Bool {
        return lhs.rawValue > rhs.rawValue
    }
}

/// 请在 "Swift Compiler - Custom Flags" 选项查找 "Other Swift Flags" 然后在DEBUG配置那里添加"-D DEBUG".

public struct XTILoger {
    private static var _default: XTILoger!
    public static var `default`: XTILoger {
        if _default == nil {
            _default = XTILoger()
        }
        return _default!
    }

    let dateFormatter = DateFormatter()
    let dateShortFormatter = DateFormatter()

    /// 保存到日志文件的等级
    public var saveFileLevel = XTILogerLevel.warning
    /// 文件名字格式，支持Y(year)、WY(weekOfYear)、M(month)、D(day) 例如，以2018/3/21为例 "Y-WY"=>2018Y-12WY "Y-M-D"=>2018Y-3M-21D "Y-M"=>2018Y-3M，通过这类的组合可以构成一个日志文件保存一天、一周、一个月、一年等方式。建议使用"Y-WY" or "Y-M"，一定要用"-"隔开
    public var fileFormatter = "Y-WY"
    /// 是否打印时间戳
    public var isShowLongTime = true

    /// 是否打印日志等级
    public var isShowLevel = true
    /// 是否打印线程
    public var isShowThread = true
    /// release模式下默认打印日志的等级
    public var releaseLogLevel: XTILogerLevel!

    /// debug模式下默认打印日志的等级
    public var debugLogLevel: XTILogerLevel!

    /// 是否打印文件名
    public var isShowFileName = true

    /// 是否打印调用所在的函数名字
    public var isShowFunctionName = true

    /// 是否打印调用所在的行数
    public var isShowLineNumber = true
    
    private var logLevel: XTILogerLevel! {
        #if DEBUG
            return debugLogLevel
        #else
            return self.releaseLogLevel
        #endif
    }

    public init() {
        self.dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        self.dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
        self.dateShortFormatter.locale = Locale(identifier: "en_US_POSIX")
        self.dateShortFormatter.dateFormat = "HH:mm:ss.SSS"
        self.debugLogLevel = XTILogerLevel.all
        self.releaseLogLevel = XTILogerLevel.warning
    }

    @discardableResult public func info(format: String,
                                        args: CVarArg...,
                                        function: String = #function,
                                        file: String = #file,
                                        line: Int = #line) -> String {
        if self.logLevel <= .info {
            return self.log(.info, function: function, file: file, line: line, format: format, args: args)
        }
        return ""
    }

    @discardableResult public func info(_ value: Any!,
                                        function: String = #function,
                                        file: String = #file,
                                        line: Int = #line) -> String {
        return self.info(format: String(describing: value), function: function, file: file, line: line)
    }

    @discardableResult public func debug(format: String,
                                         args: CVarArg...,
                                         function: String = #function,
                                         file: String = #file,
                                         line: Int = #line) -> String {
        if self.logLevel <= .debug {
            return self.log(.debug, function: function, file: file, line: line, format: format, args: args)
        }
        return ""
    }

    @discardableResult public func debug(_ value: Any!,
                                         function: String = #function,
                                         file: String = #file,
                                         line: Int = #line) -> String {
        return self.debug(format: String(describing: value), function: function, file: file, line: line)
    }

    @discardableResult public func warning(format: String,
                                           args: CVarArg...,
                                           function: String = #function,
                                           file: String = #file,
                                           line: Int = #line) -> String {
        if self.logLevel <= .warning {
            return self.log(.warning, function: function, file: file, line: line, format: format, args: args)
        }
        return ""
    }

    @discardableResult public func warning(_ value: Any!,
                                           function: String = #function,
                                           file: String = #file,
                                           line: Int = #line) -> String {
        return self.warning(format: String(describing: value), function: function, file: file, line: line)
    }

    @discardableResult public func error(format: String,
                                         args: CVarArg...,
                                         function: String = #function,
                                         file: String = #file,
                                         line: Int = #line) -> String {
        if self.logLevel <= .error {
            return self.log(.error, function: function, file: file, line: line, format: format, args: args)
        }
        return ""
    }

    @discardableResult public func error(_ value: Any!,
                                         function: String = #function,
                                         file: String = #file,
                                         line: Int = #line) -> String {
        return self.error(format: String(describing: value), function: function, file: file, line: line)
    }

    /// 打印日志
    ///
    /// - Parameters:
    ///   - level: 日志等级
    ///   - format: 要打印的数据的结构
    ///   - args: 要打印的数据数组
    /// - Returns: 打印的内容
    fileprivate func log(_ level: XTILogerLevel,
                         function: String,
                         file: String,
                         line: Int,
                         format: String,
                         args: [CVarArg]) -> String {
        let dateTime = isShowLongTime ? "\(dateFormatter.string(from: Date())) " : "\(dateShortFormatter.string(from: Date())) "
        var levelString = ""
        switch level {
        case .info:
            levelString = "[ INFO  ] "
        case .debug:
            levelString = "[ DEBUG ] "
        case .warning:
            levelString = "[WARNING] "
        case .error:
            levelString = "[ ERROR ] "
        default:
            break
        }
        levelString = self.isShowLevel ? levelString : ""

        var fileString = ""
        if self.isShowFileName {
            fileString += "[" + (file as NSString).lastPathComponent
            if self.isShowLineNumber {
                fileString += ":\(line)"
            }
            fileString += "] "
        }
        if fileString.isEmpty && self.isShowLineNumber {
            fileString = "line:\(line) "
        }
        var functionString = isShowFunctionName ? function : ""
        functionString = functionString + " "
        let message: String
        if args.count == 0 {
            message = format
        } else {
            message = String(format: format, arguments: args)
        }

        let threadId = String(unsafeBitCast(Thread.current, to: Int.self), radix: 16, uppercase: false)
        let isMain = isShowThread ? Thread.current.isMainThread ? "[Main] " : "[Global]<0x\(threadId)> " : ""
        let infoString = "\(dateTime)\(levelString)\(fileString)\(isMain)\(functionString)".trimmingCharacters(in: CharacterSet(charactersIn: " "))
        let logString = infoString + (infoString.isEmpty ? "" : " => ") + "\(message)"

        self.xt_print(logString)
        self.printToFile(level, log: logString)
        return logString + "\n"
    }

    /// 通过日志等级获取当前日志文件的路径
    ///
    /// - Parameter level: 日志等级
    /// - Returns: 文件路径
    public func getCurrentLogFilePath(_ level: XTILogerLevel) -> String {
        let fileName = self.returnFileName(level)
        let logFilePath = self.getLogDirectory() + fileName
        if !FileManager.default.fileExists(atPath: logFilePath) {
            FileManager.default.createFile(atPath: logFilePath, contents: nil, attributes: nil)
        }
        return logFilePath
    }

    /// 获取日志文件夹的路径，没有该文件夹就创建
    ///
    /// - Returns: 日志文件夹的路径
    public func getLogDirectory() -> String {
        let logDirectoryPath = NSHomeDirectory() + "/Documents/XTILoger/"
        if !FileManager.default.fileExists(atPath: logDirectoryPath) {
            try? FileManager.default.createDirectory(atPath: logDirectoryPath, withIntermediateDirectories: true, attributes: nil)
        }
        return logDirectoryPath
    }

    /// 获取所有日志文件的路径
    ///
    /// - Returns: 所有日志文件的路径
    public func getLogFilesPath() -> [String] {
        var filesPath = [String]()
        do {
            filesPath = try FileManager.default.contentsOfDirectory(atPath: self.getLogDirectory())
        } catch {}
        return filesPath
    }

    /// 清理日志文件
    ///
    /// - Returns: 操作结果
    @discardableResult public func cleanLogFiles() -> Bool {
        self.getLogFilesPath().forEach { path in
            do { try FileManager.default.removeItem(atPath: path) } catch {}
        }
        return self.getLogFilesPath().isEmpty
    }

    fileprivate func xt_print(_ string: String) {
        #if DEBUG
            print(string)
        #endif
    }

    fileprivate func printToFile(_ level: XTILogerLevel, log string: String) {
        if self.logLevel > level {
            return
        }
        let logFilePath = self.getCurrentLogFilePath(level)
        if FileManager.default.fileExists(atPath: logFilePath) {
            let writeHandler = FileHandle(forWritingAtPath: logFilePath)
            writeHandler?.seekToEndOfFile()
            if let data = ("\n" + string).data(using: String.Encoding.utf8) {
                writeHandler?.write(data)
            }
            writeHandler?.closeFile()
        } else {
            FileManager.default.createFile(atPath: logFilePath, contents: string.data(using: String.Encoding.utf8), attributes: nil)
        }
    }

    fileprivate func returnFileName(_ level: XTILogerLevel) -> String {
        var fileNameString = ""
        switch level {
        case .info:
            fileNameString = "info"
        case .debug:
            fileNameString = "debug"
        case .warning:
            fileNameString = "warning"
        case .error:
            fileNameString = "error"
        default:
            break
        }
        let dateComponents = Calendar.current.dateComponents(Set<Calendar.Component>.init(arrayLiteral: .year, .month, .day, .weekOfYear), from: Date())
        let fileFormatters = fileFormatter.components(separatedBy: "-")
        fileFormatters.forEach { string in
            switch string {
            case "D":
                fileNameString += "-\(dateComponents.day!)d"
            case "WY":
                fileNameString += "-\(dateComponents.weekOfYear!)wy"
            case "M":
                fileNameString += "-\(dateComponents.month!)m"
            case "Y":
                fileNameString += "-\(dateComponents.year!)y"
            default:
                break
            }
        }
        fileNameString += ".log"
        return fileNameString
    }
}
