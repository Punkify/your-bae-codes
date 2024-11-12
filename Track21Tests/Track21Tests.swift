//
//  TrackConstants.TARGET_DAYSTests.swift
//  TrackConstants.TARGET_DAYSTests
//
//  Created by J31065 on 4/11/2024.
//
@testable import TrackConstants.TARGET_DAYS
import Testing
import SwiftData
import Foundation


@MainActor
struct TrackConstants.TARGET_DAYSTests {
        
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
    
    @Test("should undo the increment daysCount when undoTrack is called.") func testHabitDaysCountIncrementUndo() async throws {
        let habit = Habit(name: "TestName", updatedAt: Date(), daysCount: 15)
        context.insert(undoTrack(habit))
     
        
        let fetchDescriptor = FetchDescriptor<Habit>()
        let result = try? context.fetch(fetchDescriptor)
        
        #expect(result![0].daysCount == 14)
    }
    
    @Test("should not undo the increment if daysCount is 0.") func testHabitDaysCountIncrementFreezeUndo() async throws {
        let habit = Habit(name: "TestName", updatedAt: Date(), daysCount: 0)
        context.insert(undoTrack(habit))
     
        
        let fetchDescriptor = FetchDescriptor<Habit>()
        let result = try? context.fetch(fetchDescriptor)
        
        #expect(result![0].daysCount == 0)
    }
    
    @Test("should not increment daysCount with 1 when habitCount is Constants.TARGET_DAYS.") func testHabitDaysCountNoIncrement() async throws {
        let habit = Habit(name: "TestName", updatedAt: Date(), daysCount: Constants.TARGET_DAYS)
        context.insert(trackHabit(habit))
     
        
        let fetchDescriptor = FetchDescriptor<Habit>()
        let result = try? context.fetch(fetchDescriptor)
        
        #expect(result![0].daysCount == Constants.TARGET_DAYS)
    }
    
    @Test("should change the isComplete value to true when habit is tracked for Constants().TARGET_DAYS days.") func testIsComplete() async throws {
        let habit = Habit(name: "TestName", updatedAt: Date(), daysCount: 20)
        context.insert(trackHabit(habit))
   
        let fetchDescriptor = FetchDescriptor<Habit>()
        let result = try? context.fetch(fetchDescriptor)
        
        print("habit details", habit.name, result![0].daysCount)
        
        #expect(result![0].daysCount == Constants.TARGET_DAYS)
        #expect(result![0].isComplete == true)
    }
}
