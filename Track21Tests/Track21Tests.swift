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
        let habit = Habit(name: "TestName", updatedAt: createdDate, daysCount: 0)
        context.insert(habit)
        
        let fetchDescriptor = FetchDescriptor<Habit>()
        let result = try? context.fetch(fetchDescriptor)
        #expect(result != [])
        
    }
    
    @Test("should insert multiple Habits") func testMultipleHabitInsertion() async throws {
        let habit = Habit(name: "TestName", updatedAt: Date(), daysCount: 0)
        let secondHabit = Habit(name: "SecondName", updatedAt: Date(), daysCount: 0)
        
        context.insert(habit)
        context.insert(secondHabit)

        #expect(habit.name == "TestName")
        #expect(secondHabit.name == "SecondName")

    }
    
    @Test("should delete Habit when delete context is called.") func testHabitDeletion() async throws {
        let habit = Habit(name: "TestName", updatedAt: Date(), daysCount: 0)
        
        context.insert(habit)
        context.delete(habit)
        
        let fetchDescriptor = FetchDescriptor<Habit>()
        let result = try? context.fetch(fetchDescriptor)
        #expect(result == [])
    }
    
    @Test("should delete MultipleHabits when delete context is called.") func testMultipleHabitDeletion() async throws {
        let habit = Habit(name: "TestName", updatedAt: Date(), daysCount: 0)
        let secondHabit = Habit(name: "TestName", updatedAt: Date(), daysCount: 0)
        
        context.insert(habit)
        context.insert(secondHabit)
        
        context.delete(habit)
        context.delete(secondHabit)
        
        let fetchDescriptor = FetchDescriptor<Habit>()
        let result = try? context.fetch(fetchDescriptor)
        #expect(result == [])
    }
    
    @Test("should add daysCount to habits when habit  is tracked.") func testHabitDaysCount() async throws {
        let habit = Habit(name: "TestName", updatedAt: Date(), daysCount: 0)
        context.insert(trackHabit(habit: habit))
     
        
        let fetchDescriptor = FetchDescriptor<Habit>()
        let result = try? context.fetch(fetchDescriptor)
        
        #expect(result![0].daysCount == 1)
    }
    
    @Test("should increment daysCount with 1 for habits when habit  is tracked.") func testHabitDaysCountIncrement() async throws {
        let habit = Habit(name: "TestName", updatedAt: Date(), daysCount: 15)
        context.insert(trackHabit(habit: habit))
     
        
        let fetchDescriptor = FetchDescriptor<Habit>()
        let result = try? context.fetch(fetchDescriptor)
        
        #expect(result![0].daysCount == 16)
    }
    

}
