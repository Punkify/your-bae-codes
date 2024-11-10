//
//  ContentView.swift
//  Track21
//
//  Created by J31065 on 4/11/2024.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var habits: [Habit]

    var body: some View {
        NavigationSplitView {
            List {
                ForEach(habits) { habit in
                    NavigationLink {
                        VStack {
                         
                            if habit.daysCount == 0 {
                                Text("No tracking for \(habit.name)")
                                    .padding(5)
                            }
                            else if habit.daysCount == 21 {
                                Image(systemName: "checkmark.circle.fill")
                                    .font(.system(size: 24))
                                    .foregroundColor(.green)
                                Text("Congratulations! You have tracked 21 days in a row!")
                                    .padding(20)
                                Image(systemName: "hands.clap")
                                    .font(.system(size: 24))
                                    .foregroundColor(.green)
                            }
                            else {
                                Image(systemName: "flame")
                                    .font(.system(size: 24))
                                    .foregroundColor(.blue) .padding(5)
                                Text("Day \(habit.daysCount) has been tracked successfully")
                                    .padding(10)
                            }
                         
                            HStack {
                                
                                Button(action: {
                                let habit = trackHabit(habit)
                                modelContext.insert(habit)
                            }) {
                                Label("Track", systemImage: "trash")
                            }
                            .padding(10)
                                Button(action: {
                                let habit = undoTrack(habit)
                                modelContext.insert(habit)
                            }) {
                                Label("Undo", systemImage: "arrow.uturn.backward")
                            }
                                
                            }
                        }
                        
                    } label: {
                        VStack {
                            Text("\(habit.name)")
                            Text("Created: \(habit.createdAt, format: Date.FormatStyle(date: .numeric, time: .shortened))")
                                .padding(2)
                            Text("Updated: \(habit.updatedAt ?? Date(), format: Date.FormatStyle(date: .numeric, time: .shortened))")
                                .padding(2)
                            Text("Cuurent Day: \(habit.daysCount) / 21")
                                .foregroundColor(Color.gray)
                                .padding(2)
                            
                            Divider()
                                .background(Color.blue)
                        }
                 
                    
                        
                    }
                }
                .onDelete(perform: deleteItems)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
                ToolbarItem {
                    Button(action: addItem) {
                        Label("Add Item", systemImage: "plus")
                    }
                }
            }
        } detail: {
            Text("Select an item")
        }
    }

    private func addItem() {
        withAnimation {
            let newItem = Habit(name: "Walk", daysCount: 0)
            modelContext.insert(newItem)
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(habits[index])
            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Habit.self, inMemory: true)
}
