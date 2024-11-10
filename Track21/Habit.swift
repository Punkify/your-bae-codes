//
//  Habit.swift
//  Track21
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
    var daysCount:Int
    var targetDate: Int = 21
    var completedDays: Date?
    var isComplete: Bool?
    
    init(name: String, habitDescription: String? = nil, updatedAt: Date? = nil, daysCount: Int) {
        self.name = name
        self.habitDescription = habitDescription
        self.updatedAt = updatedAt
        self.daysCount = daysCount
    }
    
    enum CodingKeys: String, CodingKey {
        case name, habitDescription, createdAt, updatedAt, daysComplete
    }
}

func trackHabit(_ habit: Habit) -> Habit {
    habit.updatedAt = Date()
    
    if habit.daysCount < 21 {
        habit.daysCount += 1
    }
    
    habit.isComplete = (habit.daysCount == 21)
    
    return habit
}
