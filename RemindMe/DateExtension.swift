//
//  Date.swift
//  RemindMe
//
//  Created by VM on 21/07/23.
//

import Foundation

extension Date{
    
    static let totalWeekDays = DateFormatter().shortWeekdaySymbols ?? []
    static let totalMonthsName = DateFormatter().shortMonthSymbols ?? []
    
    func formmatedDate()->String{
        let calendar = Calendar.current
        let month = Date.totalMonthsName[calendar.component(.month, from: self) - 1]
        let day = calendar.component(.day, from: self)
        let year = calendar.component(.year, from: self)
        return "\(month) \(day), \(year)"
    }
    
   static func dateFromValues(_ year: Int,_ month: Int,_ day: Int)-> Date{
        let calendar = Calendar.current
        let dateComponent = DateComponents(year: year,month: month,day: day)
        return calendar.date(from: dateComponent) ?? Date()
    }
    
    func getTimeInAMPM() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a"
        return dateFormatter.string(from: self)
    }
}

extension HomeViewController{
    
    func getDate(_ indexPathItem: Int)->Date?{
        let monthIndex = (indexPathItem / oneMonthItemsCount) + 1
        let month = (monthIndex % totalMonthsInAYear) == 0 ? 12 : (monthIndex % totalMonthsInAYear)
        var year = (monthIndex / totalMonthsInAYear) + beginYear
        if month == 12{
            year -= 1
        }
        let firstDate =  Date.dateFromValues(year,month,firstDateOfMonth)
        let weekDay = calendar.component(.weekday, from: firstDate)
        let difference = weekDay - firstDateOfMonth
        let index = indexPathItem % oneMonthItemsCount
        let day = index - totalWeekDays.count - difference + 1
        let totalDaysInMonth = (calendar.range(of: .day, in: .month, for: firstDate))?.count ?? 0
        
        var date: Date?
        
        if day > 0 && day <= totalDaysInMonth{
            date = Date.dateFromValues(year, month, day)
            
        }
        return date
        
    }
    
    func getDateItemIndex(_ date:Date)->Int{
        let month = calendar.component(.month, from: date)
        let year = calendar.component(.year, from: date)
        let monthIndex = ((year - beginYear) * totalMonthsInAYear) + month
        
        let weekDay = calendar.component(.weekday, from: date)
        let day = calendar.component(.day, from: date)
        
        var dayIndex = ((day / totalWeekDays.count) * totalWeekDays.count) + weekDay
        dayIndex = (dayIndex >= day ? dayIndex : (dayIndex + totalWeekDays.count)) + totalWeekDays.count - 1
        return dayIndex + ((monthIndex - 1) * oneMonthItemsCount)
    }
}
