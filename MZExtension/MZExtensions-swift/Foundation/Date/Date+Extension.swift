//
//  Date+Extension.swift
//  MZExtension
//
//  Created by Mr.Z on 2021/9/17.
//  Copyright © 2021 Mr.Z. All rights reserved.
//

import Foundation

extension Date {
    
    /// return date of year
    public var year: Int {
        return Calendar.current.component(.year, from: self)
    }
    
    /// return date of month
    public var month: Int {
        return Calendar.current.component(.month, from: self)
    }
    
    /// return date of day
    public var day: Int {
        return Calendar.current.component(.day, from: self)
    }
    
    /// return date of hour
    public var hour: Int {
        return Calendar.current.component(.hour, from: self)
    }
    
    /// return date of minute
    public var minute: Int {
        return Calendar.current.component(.minute, from: self)
    }
    
    /// return date of second
    public var second: Int {
        return Calendar.current.component(.second, from: self)
    }
    
    /// return date of nanosecond
    public var nanosecond: Int {
        return Calendar.current.component(.nanosecond, from: self)
    }
    
    /// return weekday(1~7)
    public var weekday: Int {
        return Calendar.current.component(.weekday, from: self)
    }
    
    /// 星期
    public var weekdayStr: String {
        let weekdays: [String] = ["周日", "周一", "周二", "周三", "周四", "周五", "周六"]
        return self.weekday < 1 || self.weekday > 7 ? "" : weekdays[self.weekday - 1]
    }
    
    /// return week of moneth(1~5)
    public var weekOfMonth: Int {
        return Calendar.current.component(.weekOfMonth, from: self)
    }
    
    /// return week of year(1~53)
    public var weekOfYead: Int {
        return Calendar.current.component(.weekOfYear, from: self)
    }
    
    /// 是否是当天
    public var isToday: Bool {
        if fabs(self.timeIntervalSinceNow) >= 60 * 60 * 24 {
            return false
        }
        return Date().day == self.day
    }
    
    /// 指定日期前n年/n月/n日或者后n年/n月/n日(负值表示前)
    public func previousOrNextDate(n: Int = 1, component: Calendar.Component = .month) -> Date {
        var datecomponents = DateComponents()
        switch component {
        case .day:
            datecomponents.day = n
        case .month:
            datecomponents.month = n
        case .year:
            datecomponents.year = n
        default:
            datecomponents.month = n
        }
        let newDate = Calendar.current.date(byAdding: datecomponents, to: self, wrappingComponents: false)
        return newDate ?? Date()
    }
    
    /// return a formatter string representing this date
    public func string(with format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.locale = Locale.current
        return formatter.string(from: self)
    }
    
    /// return a formatter date from string
    static public func date(with dateString: String, format: String) -> Date {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.locale = Locale.current
        return formatter.date(from: dateString) ?? Date()
    }
    
    /// return a formatter date from GMT date
    static public func dateFromGMT(_ date: Date) -> Date {
        let secondFromGMT: TimeInterval = TimeInterval(TimeZone.current.secondsFromGMT(for: date))
        return date.addingTimeInterval(secondFromGMT)
    }
    
    /// 计算年龄
    public func calculateAge() -> Int {
        var age = Date().year - self.year - 1
        if (Date().month > self.month) || (Date().month == self.month && Date().day >= self.day) {
            age += 1
        }
        return age
    }
    
    /// 计算星座
    public func calculateConstellation() -> String {
        guard let calendar = NSCalendar(identifier: NSCalendar.Identifier.gregorian) else {
            return ""
        }
        let components = calendar.components([.month, .day], from: self)
        let month = components.month!
        let day = components.day!
        // 月以100倍之月作为一个数字计算出来
        let mmdd = month * 100 + day
        var result = ""
        if ((mmdd >= 321 && mmdd <= 331) || (mmdd >= 401 && mmdd <= 419)) {
            result = "白羊座"
        } else if ((mmdd >= 420 && mmdd <= 430) || (mmdd >= 501 && mmdd <= 520)) {
            result = "金牛座"
        } else if ((mmdd >= 521 && mmdd <= 531) || (mmdd >= 601 && mmdd <= 621)) {
            result = "双子座"
        } else if ((mmdd >= 622 && mmdd <= 630) || (mmdd >= 701 && mmdd <= 722)) {
            result = "巨蟹座"
        } else if ((mmdd >= 723 && mmdd <= 731) || (mmdd >= 801 && mmdd <= 822)) {
            result = "狮子座"
        } else if ((mmdd >= 823 && mmdd <= 831) || (mmdd >= 901 && mmdd <= 922)) {
            result = "处女座"
        } else if ((mmdd >= 923 && mmdd <= 930) || (mmdd >= 1001 && mmdd <= 1023)) {
            result = "天秤座"
        } else if ((mmdd >= 1024 && mmdd <= 1031) || (mmdd >= 1101 && mmdd <= 1122)) {
            result = "天蝎座"
        } else if ((mmdd >= 1123 && mmdd <= 1130) || (mmdd >= 1201 && mmdd <= 1221)) {
            result = "射手座"
        } else if ((mmdd >= 1222 && mmdd <= 1231) || (mmdd >= 101 && mmdd <= 119)) {
            result = "摩羯座"
        } else if ((mmdd >= 120 && mmdd <= 131) || (mmdd >= 201 && mmdd <= 218)) {
            result = "水瓶座"
        } else if ((mmdd >= 219 && mmdd <= 229) || (mmdd >= 301 && mmdd <= 320)) {
            // 考虑到2月闰年有29天的
            result = "双鱼座"
        } else {
            result = "日期错误"
        }
        return result
    }
    
    public func messageString() -> String {
        let components = Calendar.current.dateComponents([.day, .month, .year], from: self)
        let nowComponents = Calendar.current.dateComponents([.day, .month, .year], from: Date())
        let dateFormatter = DateFormatter()
        var isYesterday = false
        if nowComponents.year != components.year {
            dateFormatter.dateFormat = "yyyy/MM/dd"
        } else {
            if nowComponents.day == components.day {
                dateFormatter.dateFormat = "HH:mm"
            } else if ((nowComponents.day! - components.day!) == 1) {
                isYesterday = true
                dateFormatter.amSymbol = "上午"
                dateFormatter.pmSymbol = "下午"
                dateFormatter.dateFormat = "HH:mm"
            } else {
                if ((nowComponents.day! - components.day!) <= 7) {
                    dateFormatter.dateFormat = "EEEE"
                } else {
                    dateFormatter.dateFormat = "yyyy/MM/dd"
                }
            }
        }
        let result = dateFormatter.string(from: self)
        return isYesterday ? "昨天 " + result : result
    }
}
