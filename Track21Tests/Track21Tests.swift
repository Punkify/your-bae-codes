//
//  Track21Tests.swift
//  Track21Tests
//
//  Created by J31065 on 4/11/2024.
//
@testable import Track21
import Testing
import SwiftData
import Foundation


@MainActor
struct Track21Tests {
        
        private var context: ModelContext!
    
        let container = try? ModelContainer(
            for: Habit.self,
            configurations: ModelConfiguration(isStoredInMemoryOnly: true)
        )

    init() {
        self.context = container?.mainContext
    }
    
    
    @Test("should insert into Habit Mode when insert context is called.") func testHabitInsertion() async throws {
        let createdDate = Date()
        let habit = Habit(name: "TestName", createdAt: createdDate)
        context.insert(habit)
        #expect(habit.name == "TestName")
        #expect(habit.createdAt == createdDate)
    }
    
    @Test("should add multiple Habits") func testMultipleHabitInsertion() async throws {
        let createdDate = Date()
        let habit = Habit(name: "TestName", createdAt: createdDate)
        let secondHabit = Habit(name: "TestName", createdAt: createdDate)
        let habits = [habit, secondHabit]
        context.insert(habit)
        context.insert(secondHabit)
        #expect(habits.count == 2)

    }
    
   


}
