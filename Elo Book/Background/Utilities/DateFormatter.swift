//
//  DateFormatter.swift
//  EloBook
//
//  Created by Jed Kutai on 11/1/23.
//

import SwiftUI
import Firebase
import Foundation
import FirebaseFirestore

class DateFormatter {
    
    static func timeToString(time: Double) -> String {
        let t = time * -1
        
        let minute: Double = 60
        let hour: Double = 60 * minute
        let day: Double = 24 * hour
        let week: Double = 7 * day
        
        if t > 0 {
            if t <= minute {
                return "Now"
            } else if t <= hour {
                let gap = Int(round(t/minute))
                return "\(gap) min"
            } else if t <= day {
                let gap = Int(round(t/hour))
                return gap > 1 ? "\(gap) hrs" : "\(gap) hr"
            } else if t < week {
                let gap = Int(round(t/day))
                return gap > 1 ? "\(gap) days" : "\(gap) day"
            } else {
                let gap = Int(round(t/week))
                return gap > 1 ? "\(gap) weeks" : "\(gap) week"
            }
        }
        return "Error"
    }
    
    
    
    static func shortDate(timestamp: Timestamp) -> String {
        let date = timestamp.dateValue()
        
        let timePassed = self.timeToString(time: date.timeIntervalSinceNow) // this returns how many seconds ago
        return timePassed
    }
    
    static func longDate(timestamp: Timestamp) -> String {
        let date = timestamp.dateValue()

        return date.formatted()
    }
    
}

