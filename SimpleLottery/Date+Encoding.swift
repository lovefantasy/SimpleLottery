//
//  Date+Encoding.swift
//  SimpleLottery
//
//  Created by 張智光 on 2018/1/1.
//  Copyright © 2018年 HardMode. All rights reserved.
//

import Foundation

extension Date {
    static func currentDate() -> Int32 {
        let currentDateTime = Date()
        let userCalendar = Calendar.current
        let requestedComponents: Set<Calendar.Component> = [.year, .month, .day]
        let dateTimeComponents = userCalendar.dateComponents(requestedComponents, from: currentDateTime)
        
        if let year = dateTimeComponents.year, let month = dateTimeComponents.month, let day = dateTimeComponents.day {
            let dateCode = Int32(year)*10000 + Int32(month)*100 + Int32(day)
            return dateCode
        } else {
            return 0
        }
    }
}
