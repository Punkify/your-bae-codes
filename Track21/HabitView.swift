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
    @State private var showAddHabitView = false
    @Query private var habits: [Habit]
    @State private var notes: String  = ""

    var body: some View {
            
            NavigationSplitView {
                List {
                    
                    ForEach(habits) { habit in
                        NavigationLink {
                            VStack {
                                
                                if habit.daysCount == 0 {
                                    
                                    DefaultView(habit: habit)
                                    
                                }
                                else if habit.daysCount == Constants().TARGET_DAYS {
                                    
                                    TrackView(habit: habit)
                                    
                                }
                                
                                else {
                                    
                                    SuccessView(habit: habit)
                                }
                                
                                TextField("add a note", text: $notes)
                                    .multilineTextAlignment(.center)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                    .onSubmit {
                                        addNotes(habit: habit)
                                    }
                                    .padding()
                                
                                HStack {
                                    
                                    Button(action: {
                                        let habit = trackHabit(habit)
                                        if !notes.isEmpty {
                                            addNotes(habit: habit)
                                        }
                                        modelContext.insert(habit)
                                        
                                        notes = ""
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
                                
                                VStack {
                                    Text(!habit.notes.isEmpty ? "Notes : " : "")
                                    ForEach(habit.notes, id: \.self) { note in
                                        Text("\(note)")
                                            .padding(1)
                                    }
                                    
                                    
                                }
                                
                                DayGridView()
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
                                    
                                }
                                
                                
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
                        Button(action: {
                            showAddHabitView = true
                        }) {
                            Label("Add Item", systemImage: "plus")
                        }
                    }
                }
            }
          
            
            detail: {
                Text("Select an item")
            }
            .background(
                Image("wallpaper")
                    .resizable()
                    .scaledToFit()
            )
            .fullScreenCover(isPresented: $showAddHabitView) { //
                AddHabitView()
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
    
    private func addNotes(habit: Habit){
        withAnimation {
            let fetchDescriptor = FetchDescriptor<Habit>()
            let result = try? modelContext.fetch(fetchDescriptor)
            
            result?.filter { habit.id == $0.id }.forEach {
                $0.notes.append(notes)
                modelContext.insert($0)
            }
        }
    }
    
    
  
}

struct SuccessView : View {
    var habit: Habit
    var body: some View {
        Image(systemName: "flame")
            .font(.system(size: 24))
            .foregroundColor(.blue) .padding(5)
        Text("Day \(habit.daysCount) has been tracked successfully")
            .padding(10)
        Text(habit.updatedAt != nil ? "Updated: \(formattedDate(date: habit.updatedAt!))" : "")
            .padding(20)
        
    }
}

struct TrackView : View {
    var habit: Habit
    var body: some View {
        Image(systemName: "checkmark.circle.fill")
            .font(.system(size: 24))
            .foregroundColor(.green)
        Text("Congratulations! You have tracked \(Constants().TARGET_DAYS) days in a row!")
            .padding(20)
        Image(systemName: "hands.clap")
            .font(.system(size: 24))
            .foregroundColor(.green)
        
    }
}

struct DefaultView : View {
    var habit: Habit
    var body: some View {
        Text("No tracking for \(habit.name)")
            .padding(5)
        
    }
}
   
#Preview {
    HabitView()
        .modelContainer(for: Habit.self, inMemory: true)
}

