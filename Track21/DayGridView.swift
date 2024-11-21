//
//  DayGridView.swift
//  Track21
//
//  Created by J31065 on 21/11/2024.
//

import SwiftUI
import SwiftData


struct DayGridView: View {
    @Query private var habits: [Habit]
    
    let days = Array(1...21) // Days 1 to 21
    let columns = Array(repeating: GridItem(.flexible(), spacing: 10), count: 5) // 5 columns
    
    // Example conditions
    func color(for day: Int) -> Color {
        
        for habit in habits where habit.daysCount == day{
            return .green
        }
        
        for habit in habits where habit.daysCount > day{
            return .green
        }
//        for habit in habits where habit.daysCount > day{
//            return .green
//        }

        return .brown
    }

    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 10) {
                ForEach(days, id: \.self) { day in
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(color(for: day)) // Dynamic color based on condition
                            .frame(height: 100) // Box height
                        
                        Text("Day \(day)")
                            .font(.headline)
                            .foregroundColor(.white)
                    }
                }
            }
            .padding(10) // Padding around the grid
        }
    }
}
#Preview {
    DayGridView()
}
