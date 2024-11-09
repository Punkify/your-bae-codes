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
    var createdAt: Date
    var updatedAt: Date?
    
    init(name: String, habitDescription: String? = nil, createdAt: Date, updatedAt: Date? = nil) {
        self.name = name
        self.habitDescription = habitDescription
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}
