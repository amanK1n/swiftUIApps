//
//  TaskDetailsView.swift
//  MyTask
//
//  Created by comviva on 16/10/26.
//
import SwiftUI

struct TaskDetailsView: View {
    @ObservedObject var taskViewModel: TaskViewModel
    @Binding var showTaskDetailsView: Bool
    @Binding var selectedTask: Task
    var body: some View {
        NavigationStack {
            List {
                Section(header: Text("Task Details")) {
                    TextField("Task name", text: $selectedTask.name)
                    TextEditor(text: $selectedTask.description)
                    Toggle("Mark complete", isOn: $selectedTask.isCompleted)
                    
                }
                Section(header: Text("Task date/time")) {
                    DatePicker("Task date", selection: $selectedTask.finishDate)
                }
                
                Section {
                    Button {
                        print("delete taskksks")
                    } label: {
                        Text("Delete")
                            .fontWeight(.bold)
                            .foregroundStyle(.red)
                            .frame(maxWidth: .infinity, alignment: .center)
                    }

                }
                
                
            }.navigationTitle("Task Details")
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Button {
                            showTaskDetailsView = false
                            print("Cancel button tapped")
                        } label: {
                            Text("Cancel")
                        }

                    }
                    
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            showTaskDetailsView = false
                            
                            print("Update button tapped")
                            print(selectedTask.name)
                            print(selectedTask.description)
                            print(selectedTask.isCompleted)
                        } label: {
                            Text("Update")
                        }

                    }
                    
                }
        }
    }
}
