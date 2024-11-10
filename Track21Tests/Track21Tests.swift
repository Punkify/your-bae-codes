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
        context.insert(trackHabit(habit))
     
        
        let fetchDescriptor = FetchDescriptor<Habit>()
        let result = try? context.fetch(fetchDescriptor)
        
        #expect(result![0].daysCount == 1)
    }
    
    @Test("should increment daysCount with 1 when habit is tracked.") func testHabitDaysCountIncrement() async throws {
        let habit = Habit(name: "TestName", updatedAt: Date(), daysCount: 15)
        context.insert(trackHabit(habit))
     
        
        let fetchDescriptor = FetchDescriptor<Habit>()
        let result = try? context.fetch(fetchDescriptor)
        
        #expect(result![0].daysCount == 16)
    }
    
    @Test("should not increment daysCount with 1 when habitCount is 21.") func testHabitDaysCountNoIncrement() async throws {
        let habit = Habit(name: "TestName", updatedAt: Date(), daysCount: 21)
        context.insert(trackHabit(habit))
     
        
        let fetchDescriptor = FetchDescriptor<Habit>()
        let result = try? context.fetch(fetchDescriptor)
        
        #expect(result![0].daysCount == 21)
    }
    
    @Test("should change the isComplete value to true when habit is tracked for 21 days.") func testIsComplete() async throws {
        let habit = Habit(name: "TestName", updatedAt: Date(), daysCount: 20)
        context.insert(trackHabit(habit))
   
        let fetchDescriptor = FetchDescriptor<Habit>()
        let result = try? context.fetch(fetchDescriptor)
        
        print("habit details", habit.name, result![0].daysCount)
        
        #expect(result![0].daysCount == 21)
        #expect(result![0].isComplete == true)
    }
    
    

}
