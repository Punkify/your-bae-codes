//
//  addHabitView.swift
//  Track21
//
//  Created by J31065 on 17/11/2024.
//
import SwiftUI

struct AddHabitView: View {
    
    @State private var habit: String = ""
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack {
            // Title
            Text("Add a New Habit")
                .font(.title)
                .fontWeight(.bold)
                .padding(.top, 40)
                .foregroundColor(.blue)
            
            // Text Field
            TextField("Enter habit name", text: $habit)
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.white)
                        .shadow(color: .black.opacity(0.1), radius: 4, x: 2, y: 2)
                )
                .padding(.horizontal)
                .font(.system(size: 16))
            
            // Save Button
            Button(action: {
                if !habit.isEmpty {
                    let habitData = Habit(name: habit)
                    modelContext.insert(habitData)
                    dismiss()
                }
            }) {
                Text("Save Habit")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(
                        LinearGradient(gradient: Gradient(colors: [Color.blue, Color.green]),
                                       startPoint: .leading,
                                       endPoint: .trailing)
                    )
                    .cornerRadius(12)
                    .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 5)
            }
            .padding(.horizontal)
            .padding(.top, 20)
            
            // Cancel Button
            Button(action: {
                dismiss()
            }) {
                Image(systemName: "xmark.circle.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 50, height: 50)
                    .foregroundStyle(
                        LinearGradient(
                            gradient: Gradient(colors: [.blue, .gray]),
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .padding()
            }
            .padding(.top, 40)
            
            Spacer()
        }
        .padding()
        .background(
            LinearGradient(
                gradient: Gradient(colors: [Color("BackgroundStart"), Color("BackgroundEnd")]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .edgesIgnoringSafeArea(.all)
        )
    }
}

#Preview {
    AddHabitView()
}

