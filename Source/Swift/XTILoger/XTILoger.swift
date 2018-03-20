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
    public static func <(lhs: XTILogerLevel, rhs: XTILogerLevel) -> Bool {
        return lhs.rawValue < rhs.rawValue
    }
    
    public static func <=(lhs: XTILogerLevel, rhs: XTILogerLevel) -> Bool {
        return lhs.rawValue <= rhs.rawValue
    }
    
    public static func >=(lhs: XTILogerLevel, rhs: XTILogerLevel) -> Bool {
        return lhs.rawValue >= rhs.rawValue
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
    
    init() {
        self.dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        self.dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
        self.dateShortFormatter.locale = Locale(identifier: "en_US_POSIX")
        self.dateShortFormatter.dateFormat = "HH:mm:ss.SSS"
        self.debugLogLevel = XTILogerLevel.all
        self.releaseLogLevel = XTILogerLevel.error
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
    
    @discardableResult public func info<T>(_ value: T,
                                           function: String = #function,
                                           file: String = #file,
                                           line: Int = #line) -> String {
        return self.info(format: "\(value)", function: function, file: file, line: line)
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
    
    @discardableResult public func debug<T>(_ value: T,
                                            function: String = #function,
                                            file: String = #file,
                                            line: Int = #line) -> String {
        return self.debug(format: "\(value)", function: function, file: file, line: line)
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
    
    @discardableResult public func warning<T>(_ value: T,
                                              function: String = #function,
                                              file: String = #file,
                                              line: Int = #line) -> String {
        return self.warning(format: "\(value)", function: function, file: file, line: line)
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
    
    @discardableResult public func error<T>(_ value: T,
                                            function: String = #function,
                                            file: String = #file,
                                            line: Int = #line) -> String {
        return self.error(format: "\(value)", function: function, file: file, line: line)
    }
    
    /// 打印日志
    ///
    /// - Parameters:
    ///   - level: 日志等级
    ///   - format: 要打印的数据的结构
    ///   - args: 要打印的数据数组
    /// - Returns: 打印的内容
    @discardableResult fileprivate func log(_ level: XTILogerLevel,
                                            function: String = #function,
                                            file: String = #file,
                                            line: Int = #line,
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
        return logString + "\n"
    }
    
    fileprivate func xt_print(_ string: String) {
        #if DEBUG
            print(string)
        #endif
    }
}
