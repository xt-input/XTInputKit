//
//  XTIDate+.swift
//  XTInputKit
//
//  Created by Input on 2017/3/7.
//  Copyright © 2017年 xt-hacker.com. All rights reserved.
//

import Foundation

private let XTI_MINUTE = 60.0
private let XTI_HOUR = 3600.0
private let XTI_DAY = 86400.0
private let XTI_WEEK = 604800.0
private let XTI_MONTH = 2592000.0
private let XTI_YEAR = 31556926.0

private let XTI_COMPONENT = Calendar.Component.self
private let XTI_COMPONENTS = Set<Calendar.Component>.init(arrayLiteral: .era, .year, .month, .day, .hour, .minute, .second, .weekday, .weekdayOrdinal, .quarter, .weekOfMonth, .weekOfYear, .yearForWeekOfYear, .nanosecond, .calendar, .timeZone)
private let XTI_CURRENT = Calendar.current

extension DateFormatter: XTIBaseNameNamespace {}
public extension XTITypeWrapperProtocol where WrappedType == DateFormatter {
    public static var dateFormatter: DateFormatter {
        return DateFormatter()
    }

    public static var defaultDateFormatter: DateFormatter {
        let date = DateFormatter()
        date.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return date
    }

    public static func dateFormatter(withFormat: String) -> DateFormatter {
        let date = DateFormatter()
        date.dateFormat = withFormat
        return date
    }
}

extension Date: XTIBaseNameNamespace {}

public extension XTITypeWrapperProtocol where WrappedType == Date {
    public static func dateFromString(_ dateString: String, format formatString: String = "yyyy-MM-dd HH:mm:ss") -> Date {
        DateFormatter.XTI.dateFormatter.dateFormat = formatString
        return DateFormatter.XTI.dateFormatter.date(from: dateString)!
    }

    public var timeIntervalDescription: String {
        let timeInterval = -wrappedValue.timeIntervalSinceNow
        if timeInterval < XTI_MINUTE {
            return "\(Int(timeInterval))s"
        } else if timeInterval < XTI_HOUR {
            return "\(Int(timeInterval / XTI_MINUTE))分钟前"
        } else if timeInterval < XTI_DAY {
            return "\(Int(timeInterval / XTI_HOUR))小时前"
        } else if timeInterval < XTI_MONTH {
            return "\(Int(timeInterval / XTI_DAY))天前"
        } else if timeInterval < XTI_YEAR {
            let dateFormatter = DateFormatter.XTI.dateFormatter(withFormat: "M月d日")
            return dateFormatter.string(from: wrappedValue)
        } else {
            return "\(Int(timeInterval / XTI_YEAR))年前"
        }
    }

    public var minuteDescription: String {
        let dateFormatter = DateFormatter.XTI.dateFormatter(withFormat: "yyyy-MM-dd")
        let theDay = dateFormatter.string(from: wrappedValue)
        let currentDay = dateFormatter.string(from: Date())
        var fix: String = ""
        if theDay == currentDay {
            dateFormatter.dateFormat = "HH:mm"
        } else if (dateFormatter.date(from: currentDay)?.timeIntervalSince(dateFormatter.date(from: theDay)!).isEqual(to: XTI_DAY))! {
            dateFormatter.dateFormat = "HH:mm"
            fix = "昨天 "
        } else if (dateFormatter.date(from: currentDay)?.timeIntervalSince(dateFormatter.date(from: theDay)!).isLess(than: XTI_WEEK))! {
            dateFormatter.dateFormat = "EEEE HH:mm"
        } else {
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        }
        return fix.appending(dateFormatter.string(from: wrappedValue))
    }

    public func descriptionWithFormat(_ format: String) -> String {
        let dateFormatter = DateFormatter.XTI.dateFormatter(withFormat: format)
        return dateFormatter.string(from: wrappedValue)
    }

    public var formattedDateDescription: String {
        let timeInterval = -wrappedValue.timeIntervalSinceNow

        let dateFormatter = DateFormatter.XTI.dateFormatter(withFormat: "yyyy-MM-dd")
        let theDay = dateFormatter.string(from: wrappedValue)
        let currentDay = dateFormatter.string(from: Date())
        let flag = dateFormatter.date(from: currentDay)?.timeIntervalSince(dateFormatter.date(from: theDay)!)

        if timeInterval < XTI_MINUTE {
            return "\(Int(timeInterval))s前"
        } else if timeInterval < XTI_HOUR {
            return "\(Int(timeInterval / XTI_MINUTE))分钟前"
        } else if timeInterval < 21600 {
            return "\(Int(timeInterval / XTI_HOUR))小时前"
        } else if theDay == currentDay {
            dateFormatter.dateFormat = "HH:mm"
            return "今天 ".appending(dateFormatter.string(from: wrappedValue))
        } else if (flag?.isEqual(to: XTI_DAY))! {
            dateFormatter.dateFormat = "HH:mm"
            return "昨天 ".appending(dateFormatter.string(from: wrappedValue))
        } else {
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
            return dateFormatter.string(from: wrappedValue)
        }
    }

    public var isToday: Bool {
        let dateFormatter = DateFormatter.XTI.dateFormatter(withFormat: "yyyy-MM-dd")
        let theDay = dateFormatter.string(from: wrappedValue)
        let currentDay = dateFormatter.string(from: Date())
        return theDay == currentDay
    }

    public var isThisWeek: Bool {
        let theWeek = self.week
        let currentWeek = Date().xti.week
        return theWeek == currentWeek
    }

    public var isThisMonth: Bool {
        let the = self.month
        let current = Date().xti.month
        return the == current
    }

    public var isThisYear: Bool {
        let the = self.year
        let current = Date().xti.year
        return the == current
    }

    // MARK: -  Comparing Dates

    public func dateByAddingDays(_ days: Int) -> Date {
        let aTimeInterval = wrappedValue.timeIntervalSinceReferenceDate + XTI_DAY * Double(days)
        return Date(timeIntervalSinceReferenceDate: aTimeInterval)
    }

    public func componentsWithOffset(from fDate: Date) -> DateComponents {
        let dTime = XTI_CURRENT.dateComponents(XTI_COMPONENTS, from: fDate, to: wrappedValue)
        return dTime
    }

    // MARK: - Retrieving Intervals

    public func minutes(after aDate: Date) -> Int {
        let ti = wrappedValue.timeIntervalSince(aDate)
        return (Int)(ti / XTI_MINUTE)
    }

    public func minutes(before bDate: Date) -> Int {
        let ti = bDate.timeIntervalSince(wrappedValue)
        return (Int)(ti / XTI_MINUTE)
    }

    public func hours(after aDate: Date) -> Int {
        let ti = wrappedValue.timeIntervalSince(aDate)
        return (Int)(ti / XTI_HOUR)
    }

    public func hours(before bDate: Date) -> Int {
        let ti = bDate.timeIntervalSince(wrappedValue)
        return (Int)(ti / XTI_HOUR)
    }

    public func days(before bDate: Date) -> Int {
        let temp = wrappedValue.timeIntervalSince(bDate)
        return (Int)(temp / XTI_DAY)
    }

    public func days(after aDate: Date) -> Int {
        let temp = aDate.timeIntervalSince(wrappedValue)
        return (Int)(temp / XTI_DAY)
    }

    public func distanceInDays(toDate tDate: Date) -> DateComponents {
        let gregorianCalendar = Calendar(identifier: Calendar.Identifier.gregorian)
        return gregorianCalendar.dateComponents(XTI_COMPONENTS, from: wrappedValue, to: tDate)
    }

    // MARK: - 时间分解

    public var year: Int {
        return XTI_CURRENT.component(XTI_COMPONENT.year, from: wrappedValue)
    }

    public var nthWeekday: Int {
        return XTI_CURRENT.component(XTI_COMPONENT.weekOfYear, from: wrappedValue)
    }

    public var weekday: Int {
        return XTI_CURRENT.component(XTI_COMPONENT.weekday, from: wrappedValue)
    }

    public var week: Int {
        return XTI_CURRENT.component(XTI_COMPONENT.weekOfYear, from: wrappedValue)
    }

    public var month: Int {
        return XTI_CURRENT.component(XTI_COMPONENT.month, from: wrappedValue)
    }

    public var day: Int {
        return XTI_CURRENT.component(XTI_COMPONENT.day, from: wrappedValue)
    }

    public var seconds: Int {
        return XTI_CURRENT.component(XTI_COMPONENT.second, from: wrappedValue)
    }

    public var minute: Int {
        return XTI_CURRENT.component(XTI_COMPONENT.minute, from: wrappedValue)
    }

    public var hour: Int {
        return XTI_CURRENT.component(XTI_COMPONENT.hour, from: wrappedValue)
    }

    public var nearestHour: Int {
        let aTimeInterval = Date().timeIntervalSinceReferenceDate + XTI_MINUTE * 30
        let newDate = Date(timeIntervalSinceReferenceDate: aTimeInterval)
        return XTI_CURRENT.component(XTI_COMPONENT.hour, from: newDate)
    }
}
