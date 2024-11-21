//
//  DayGridView.swift
//  Track21
//
//  Created by J31065 on 21/11/2024.
//

import SwiftUI
import SwiftData

struct DayGridView: View {
    @State var habit: Habit
    
    let days = Array(1...21) // Days 1 to 21
    let columns = Array(repeating: GridItem(.flexible(), spacing: 12), count: 5) // 5 columns with spacing
    
    // Example conditions
    func color(for day: Int) -> Color {
       if habit.daysCount == day {
            return .blue
        }
        if habit.daysCount > day {
            return .green
        }
        return .brown
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                LazyVGrid(columns: columns, spacing: 12) {
                    ForEach(days, id: \.self) { day in
                        ZStack {
                            RoundedRectangle(cornerRadius: 15)
                                .fill(color(for: day)) // Dynamic color based on condition
                                .frame(height: 80) // Box height
                                .shadow(color: .black.opacity(0.1), radius: 4, x: 2, y: 2)
                            
                            Text("Day \(day)")
                                .font(.headline)
                                .foregroundColor(.white)
                        }
                        .overlay(
                            RoundedRectangle(cornerRadius: 15)
                                .stroke(Color.white.opacity(0.3), lineWidth: 1)
                        )
                    }
                }
                .padding(.horizontal)
            }
            .padding(.top, 10)
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [Color("BackgroundStart"), Color("BackgroundEnd")]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .cornerRadius(20)
            .padding()
        }
    }
}

//#Preview {
//    DayGridView(habit: habit)
//        .modelContainer(for: Habit.self, inMemory: true)
//}

