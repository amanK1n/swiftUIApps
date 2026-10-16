//
//  AddTaskView.swift
//  MyTask
//
//  Created by comviva on 16/10/26.
//




import SwiftUI

struct AddTaskView: View {
    @ObservedObject var taskViewModel: TaskViewModel
    @State private var taskToAdd: Task = Task(id: 0, name: "", description: "", isCompleted: false, finishDate: Date())
    @Binding var showAddTaskView: Bool
    @Binding var refreshTaskList: Bool
    var body: some View {
        NavigationStack {
            List {
                Section(header: Text("Task Details")) {
                    TextField("Task name", text: $taskToAdd.name)
                    TextEditor(text: $taskToAdd.description)
                }
                Section(header: Text("Task date/time")) {
                    DatePicker("Task date", selection: $taskToAdd.finishDate)
                }
            }.navigationTitle("Add Task")
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Button {
                            showAddTaskView.toggle()
                            print("Cancel button tapped")
                        } label: {
                            Text("Cancel")
                        }

                    }
                    
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            print("Add button tapped")
                            taskViewModel.addTask(task: taskToAdd)
                            refreshTaskList.toggle()
                            showAddTaskView.toggle()
                            
                        } label: {
                            Text("Add")
                        }

                    }
                    
                }
        }
    }
    
}
struct AddTaskView_Previews: PreviewProvider {
    static var previews: some View {
        AddTaskView(taskViewModel: TaskViewModel(), showAddTaskView: .constant(false), refreshTaskList: .constant(false))
    }
}
