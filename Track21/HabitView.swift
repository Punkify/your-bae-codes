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
    @State private var notes: String = ""

    var body: some View {
        NavigationSplitView {
            List {
                ForEach(habits) { habit in
                    NavigationLink {
                        HabitDetailView(habit: habit, notes: $notes, modelContext: modelContext)
                    } label: {
                        HabitRowView(habit: habit)
                    }
                    .listRowBackground(Color("ListRowBackground"))
                }
                .onDelete(perform: deleteItems)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
                ToolbarItem {
                    Button(action: { showAddHabitView = true }) {
                        Label("Add Item", systemImage: "plus")
                            .foregroundColor(.blue)
                    }
                }
            }
            .background(
                Image("wallpaper")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
            )
        } detail: {
            Text("Select a habit to view details.")
                .foregroundColor(.gray)
                .font(.headline)
        }
        .fullScreenCover(isPresented: $showAddHabitView) {
            AddHabitView()
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

struct HabitDetailView: View {
    var habit: Habit
    @Binding var notes: String
    var modelContext: ModelContext

    var body: some View {
        VStack(spacing: 20) {
            Group {
                if habit.daysCount == 0 {
                    DefaultView(habit: habit)
                } else if habit.daysCount == Constants().TARGET_DAYS {
                    TrackView(habit: habit)
                } else {
                    SuccessView(habit: habit)
                }
            }
            .padding()

            TextField("Add a note", text: $notes)
                .padding()
                .background(Color("TextFieldBackground"))
                .cornerRadius(8)
                .padding(.horizontal)

            HStack(spacing: 20) {
                Button(action: {
                    let habit = trackHabit(habit)
                    if !notes.isEmpty {
                        addNotes(habit: habit)
                    }
                    modelContext.insert(habit)
                    notes = ""
                }) {
                    Label("Track", systemImage: "checkmark.circle.fill")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(8)
                }

                Button(action: {
                    let habit = undoTrack(habit)
                    modelContext.insert(habit)
                }) {
                    Label("Undo", systemImage: "arrow.uturn.backward")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.red)
                        .cornerRadius(8)
                }
            }

            VStack(alignment: .leading, spacing: 10) {
                if !habit.notes.isEmpty {
                    Text("Notes:")
                        .font(.headline)
                        .padding(.bottom, 5)
                }

                ForEach(habit.notes, id: \.self) { note in
                    Text(note)
                        .padding()
                        .background(Color("NoteBackground"))
                        .cornerRadius(8)
                }
            }
            .padding(.horizontal)
                       VStack(alignment: .leading) {
                           Text("Progress Tracker")
                               .font(.title2)
                               .fontWeight(.semibold)
                               .padding(.horizontal)
                           DayGridView(habit: habit)
                               .padding(.horizontal)
                       }
            
            Spacer()
        }
        .padding()
        .background(Color("DetailBackground"))
        .cornerRadius(10)
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

struct HabitRowView: View {
    var habit: Habit

    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(habit.name)
                .font(.headline)
            Text("Created: \(formattedDate(date: habit.createdAt))")
                .font(.subheadline)
                .foregroundColor(.secondary)

            HStack {
                Text("Current Day: \(habit.daysCount) / \(Constants().TARGET_DAYS)")
                    .font(.footnote)
                    .foregroundColor(.gray)
                Spacer()
            }
        }
        .padding()
        .background(Color("RowBackground"))
        .cornerRadius(8)
        .shadow(radius: 1)
    }
}

struct DefaultView: View {
    var habit: Habit
    var body: some View {
        Text("No tracking for \(habit.name)")
            .font(.headline)
            .foregroundColor(.gray)
            .padding()
    }
}

struct SuccessView: View {
    var habit: Habit
    var body: some View {
        VStack(spacing: 10) {
            Image(systemName: "flame.fill")
                .font(.system(size: 36))
                .foregroundColor(.orange)
            Text("Day \(habit.daysCount) has been tracked successfully.")
                .multilineTextAlignment(.center)
        }
    }
}

struct TrackView: View {
    var habit: Habit
    var body: some View {
        VStack(spacing: 10) {
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 36))
                .foregroundColor(.green)
            Text("Congratulations! You have tracked \(Constants().TARGET_DAYS) days in a row!")
                .multilineTextAlignment(.center)
                .foregroundColor(.primary)
        }
    }
}

#Preview {
    HabitView()
        .modelContainer(for: Habit.self, inMemory: true)
}
