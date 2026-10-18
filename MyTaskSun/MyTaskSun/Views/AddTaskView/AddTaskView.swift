//
//  AddTaskView.swift
//  MyTaskSun
//
//  Created by comviva on 18/10/26.
//

import SwiftUI

struct AddTaskView: View {
    @ObservedObject var taskViewModel: TaskViewModel
    @State private var taskToAdd: Task = Task(id: 0, name: "", description: "", isCompleted: false, finishDate: Date())
    @Binding var showAddTaskView: Bool
    @Binding var refreshList: Bool
    var body: some View {
        NavigationStack {
            List {
                Section(header: Text("Task Details")) {
                    TextField("Task Name", text: $taskToAdd.name)
                    TextEditor(text: $taskToAdd.description)
                }
                Section(header: Text("Task Date/Time")) {
                    DatePicker("Date", selection: $taskToAdd.finishDate)
                }
                
            }.navigationTitle("Add Task")
                .toolbar {
                    ToolbarItem(placement: .topBarPinnedTrailing) {
                        Button {
                            print("Add item clicked")
                            taskViewModel.addTask(task: taskToAdd)
                            showAddTaskView.toggle()
                            refreshList.toggle()
                        } label: {
                            Text("Add")
                                .foregroundStyle(.red)
                                .fontWeight(.heavy)
                        }.disabled(taskToAdd.name.isEmpty)
                    }
                    ToolbarItem(placement: .topBarLeading) {
                        Button {
                            print("Cancel clicked!!")
                            showAddTaskView.toggle()
                        } label: {
                            Text("Cancel")
                                .foregroundStyle(.brown)
                                .fontWeight(.semibold)
                        }

                    }
                }
        }
    }
}
