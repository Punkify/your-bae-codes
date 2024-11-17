//
//  addHabitView.swift
//  Track21
//
//  Created by J31065 on 17/11/2024.
//
import SwiftUI

struct AddHabitView: View {
    
    @State var habit: String = ""
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack {
            HStack {
                TextField("Add a habit", text: $habit)
                    .padding(20)
                    .cornerRadius(8)
                    .font(.system(size: 16))
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                    )
            }
            .edgesIgnoringSafeArea(.all)
        }
        .padding()
        Button(action: {
           let habitData = Habit(name: habit)
            modelContext.insert(habitData)
            dismiss()
            print("Habit saved!")
        }) {
            Text("Save Habit")
                .font(.headline)
                .foregroundColor(.white)
                .padding()
                .frame(maxWidth: .infinity)
                .background(
                    LinearGradient(gradient: Gradient(colors: [Color.white, Color.blue]),
                                   startPoint: .leading,
                                   endPoint: .trailing)
                )
                .cornerRadius(10)
                .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 5)
        }
        .padding(.horizontal)
    
        
    }
    
    
        
    
}

#Preview {
    AddHabitView()
}
