//
//  Habit.swift
//  TrackConstants.TARGET_DAYS
//
//  Created by J31065 on 9/11/2024.
//

import Foundation
import SwiftData

@Model
class Habit {
    @Attribute(.unique) var name: String
    var habitDescription: String?
    var createdAt: Date = Date()
    var updatedAt: Date?
    var daysCount:Int = 0
    var targetDate: Int = Constants().TARGET_DAYS
    var completedDays: Date?
    var isComplete: Bool = false
    var notes: [String]
    
    init(name: String, habitDescription: String? = nil, updatedAt: Date? = nil, daysCount: Int = 0, notes: [String] = []) {
        self.name = name
        self.habitDescription = habitDescription
        self.updatedAt = updatedAt
        self.daysCount = daysCount
        self.notes = notes
    }
    
    enum CodingKeys: String, CodingKey {
        case name, habitDescription, createdAt, updatedAt, daysComplete
    }
}

func trackHabit(_ habit: Habit) -> Habit {
    habit.updatedAt = Date()
    
    if habit.daysCount < Constants().TARGET_DAYS {
        habit.daysCount += 1
    }
    
    habit.isComplete = (habit.daysCount == Constants().TARGET_DAYS)
    
    return habit
}

func undoTrack(_ habit: Habit) -> Habit {
    habit.updatedAt = Date()
    
    if habit.daysCount > 0 {
        habit.daysCount -= 1
    }
 

    habit.isComplete = (habit.daysCount == Constants().TARGET_DAYS)
    
    return habit
}

func formattedDate (date: Date) -> String {
    let formatter = DateFormatter()
//    formatter.dateStyle = .medium
    formatter.dateFormat = "MMM d, h:mm a"
    return formatter.string(from: date)
}
