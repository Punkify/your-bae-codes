//
//  ContentView.swift
//  TrackConstants.TARGET_DAYS
//
//  Created by J31065 on 4/11/2024.
//

import SwiftUI
import SwiftData

struct HabitView: View {
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
                            else if habit.daysCount == Constants().TARGET_DAYS {
                                Image(systemName: "checkmark.circle.fill")
                                    .font(.system(size: 24))
                                    .foregroundColor(.green)
                                Text("Congratulations! You have tracked \(Constants().TARGET_DAYS) days in a row!")
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
                                Text(habit.updatedAt != nil ? "Updated: \(formattedDate(date: habit.updatedAt!))" : "")
                                    .padding(20)
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
                        VStack(alignment: .leading) {
                            Text("\(habit.name)")
                            Text("Created: \(formattedDate(date: habit.createdAt))")
                                .padding(1)
                            
                            HStack{
                                Text("Current Day: \(habit.daysCount) / \(Constants().TARGET_DAYS)")
                                    .foregroundColor(Color.gray)
                                    .padding(1)
                                Spacer()
                                Image(systemName: habit.isComplete ? "checkmark.circle.fill" : "arrow.2.circlepath")
                            }
                          
                            Divider()
                                .foregroundStyle(Color.gray)

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
    HabitView()
        .modelContainer(for: Habit.self, inMemory: true)
}

