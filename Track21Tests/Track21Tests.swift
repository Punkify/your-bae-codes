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
    
    
    @Test("should insert into Habit Model when insert context is called.") func testHabitInsertion() async throws {
        let createdDate = Date()
        let habit = Habit(name: "TestName", createdAt: createdDate)
        context.insert(habit)
        
        #expect(habit.name == "TestName")
        #expect(habit.createdAt == createdDate)
    }
    
    @Test("should add multiple Habits") func testMultipleHabitInsertion() async throws {
        let createdDate = Date()
        
        let habit = Habit(name: "TestName", createdAt: createdDate)
        let secondHabit = Habit(name: "SecondName", createdAt: createdDate)
        
        context.insert(habit)
        context.insert(secondHabit)

        #expect(habit.name == "TestName")
        #expect(secondHabit.name == "SecondName")

    }
    
    @Test("should delete Habit") func testHabitDeletion() async throws {
        let habit = Habit(name: "TestName", createdAt: Date())
        
        context.insert(habit)
        context.delete(habit)
        
        let fetchDescriptor = FetchDescriptor<Habit>()
        let result = try? context.fetch(fetchDescriptor)
        #expect(result == [])
    }
    
    @Test("should delete MultipleHabits") func testMultipleHabitDeletion() async throws {
        let habit = Habit(name: "TestName", createdAt: Date())
        let secondHabit = Habit(name: "TestName", createdAt: Date())
        
        context.insert(habit)
        context.insert(secondHabit)
        
        context.delete(habit)
        context.delete(habit)
        
        let fetchDescriptor = FetchDescriptor<Habit>()
        let result = try? context.fetch(fetchDescriptor)
        #expect(result == [])
    }
    

}
