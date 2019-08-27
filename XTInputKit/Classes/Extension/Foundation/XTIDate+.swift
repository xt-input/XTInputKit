//
//  XTIDate+.swift
//  XTInputKit
//
//  Created by xt-input on 2017/3/7.
//  Copyright © 2017年 tcoding.cn. All rights reserved.
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

private class XTIDateFormatter: DateFormatter {
    private static var _defaultDateFormatter: DateFormatter?
    static var defaultDateFormatter: DateFormatter {
        if _defaultDateFormatter == nil {
            _defaultDateFormatter = DateFormatter()
            _defaultDateFormatter?.dateFormat = "yyyy-MM-dd HH:mm:ss"
        }
        return _defaultDateFormatter!
    }

    static func dateFormatter(withFormat: String) -> DateFormatter {
        let date = DateFormatter()
        date.dateFormat = withFormat
        return date
    }
}

extension Date: XTIBaseNameNamespace {}

public extension XTITypeWrapperProtocol where WrappedType == Date {
    static func dateFromString(_ dateString: String, format formatString: String? = nil) -> Date? {
        guard let tempFormat = formatString else {
            return XTIDateFormatter.defaultDateFormatter.date(from: dateString)
        }

        return XTIDateFormatter.dateFormatter(withFormat: tempFormat).date(from: dateString)
    }

    var timeIntervalDescription: String {
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
            let dateFormatter = XTIDateFormatter.dateFormatter(withFormat: "M月d日")
            return dateFormatter.string(from: wrappedValue)
        } else {
            return "\(Int(timeInterval / XTI_YEAR))年前"
        }
    }

    var minuteDescription: String {
        let dateFormatter = XTIDateFormatter.dateFormatter(withFormat: "yyyy-MM-dd")
        let theDay = dateFormatter.string(from: wrappedValue)
        let currentDay = dateFormatter.string(from: Date())
        var fix: String = ""
        if theDay == currentDay {
            dateFormatter.dateFormat = "HH:mm"
        } else if Date().timeIntervalSince(wrappedValue).isLess(than: XTI_DAY) {
            dateFormatter.dateFormat = "HH:mm"
            fix = "昨天 "
        } else if Date().timeIntervalSince(wrappedValue).isLess(than: XTI_WEEK) {
            dateFormatter.dateFormat = "EEEE HH:mm"
        } else if Date().timeIntervalSince(wrappedValue).isLess(than: XTI_MONTH) {
            dateFormatter.dateFormat = "MM-dd HH:mm"
        } else {
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        }
        return fix.appending(dateFormatter.string(from: wrappedValue))
    }

    func descriptionWithFormat(_ format: String) -> String {
        let dateFormatter = XTIDateFormatter.dateFormatter(withFormat: format)
        return dateFormatter.string(from: wrappedValue)
    }

    var formattedDateDescription: String {
        let timeInterval = -wrappedValue.timeIntervalSinceNow

        let dateFormatter = XTIDateFormatter.dateFormatter(withFormat: "yyyy-MM-dd")
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

    var isToday: Bool {
        let dateFormatter = XTIDateFormatter.dateFormatter(withFormat: "yyyy-MM-dd")
        let theDay = dateFormatter.string(from: wrappedValue)
        let currentDay = dateFormatter.string(from: Date())
        return theDay == currentDay
    }

    var isThisWeek: Bool {
        let theWeek = self.week
        let currentWeek = Date().xti.week
        return theWeek == currentWeek
    }

    var isThisMonth: Bool {
        let the = self.month
        let current = Date().xti.month
        return the == current
    }

    var isThisYear: Bool {
        let the = self.year
        let current = Date().xti.year
        return the == current
    }

    // MARK: -  Comparing Dates

    func dateByAddingDays(_ days: Int) -> Date {
        let aTimeInterval = wrappedValue.timeIntervalSinceReferenceDate + XTI_DAY * Double(days)
        return Date(timeIntervalSinceReferenceDate: aTimeInterval)
    }

    func componentsWithOffset(from fDate: Date) -> DateComponents {
        let dTime = XTI_CURRENT.dateComponents(XTI_COMPONENTS, from: fDate, to: wrappedValue)
        return dTime
    }

    // MARK: - Retrieving Intervals

    func minutes(after aDate: Date) -> Int {
        let ti = wrappedValue.timeIntervalSince(aDate)
        return (Int)(ti / XTI_MINUTE)
    }

    func minutes(before bDate: Date) -> Int {
        let ti = bDate.timeIntervalSince(wrappedValue)
        return (Int)(ti / XTI_MINUTE)
    }

    func hours(after aDate: Date) -> Int {
        let ti = wrappedValue.timeIntervalSince(aDate)
        return (Int)(ti / XTI_HOUR)
    }

    func hours(before bDate: Date) -> Int {
        let ti = bDate.timeIntervalSince(wrappedValue)
        return (Int)(ti / XTI_HOUR)
    }

    func days(before bDate: Date) -> Int {
        let temp = wrappedValue.timeIntervalSince(bDate)
        return (Int)(temp / XTI_DAY)
    }

    func days(after aDate: Date) -> Int {
        let temp = aDate.timeIntervalSince(wrappedValue)
        return (Int)(temp / XTI_DAY)
    }

    func distanceInDays(toDate tDate: Date) -> DateComponents {
        let gregorianCalendar = Calendar(identifier: Calendar.Identifier.gregorian)
        return gregorianCalendar.dateComponents(XTI_COMPONENTS, from: wrappedValue, to: tDate)
    }

    // MARK: - 时间分解

    var year: Int {
        return XTI_CURRENT.component(XTI_COMPONENT.year, from: wrappedValue)
    }

    var nthWeekday: Int {
        return XTI_CURRENT.component(XTI_COMPONENT.weekOfYear, from: wrappedValue)
    }

    var weekday: Int {
        return XTI_CURRENT.component(XTI_COMPONENT.weekday, from: wrappedValue)
    }

    var week: Int {
        return XTI_CURRENT.component(XTI_COMPONENT.weekOfYear, from: wrappedValue)
    }

    var month: Int {
        return XTI_CURRENT.component(XTI_COMPONENT.month, from: wrappedValue)
    }

    var day: Int {
        return XTI_CURRENT.component(XTI_COMPONENT.day, from: wrappedValue)
    }

    var seconds: Int {
        return XTI_CURRENT.component(XTI_COMPONENT.second, from: wrappedValue)
    }

    var minute: Int {
        return XTI_CURRENT.component(XTI_COMPONENT.minute, from: wrappedValue)
    }

    var hour: Int {
        return XTI_CURRENT.component(XTI_COMPONENT.hour, from: wrappedValue)
    }

    var nearestHour: Int {
        let aTimeInterval = Date().timeIntervalSinceReferenceDate + XTI_MINUTE * 30
        let newDate = Date(timeIntervalSinceReferenceDate: aTimeInterval)
        return XTI_CURRENT.component(XTI_COMPONENT.hour, from: newDate)
    }
}
