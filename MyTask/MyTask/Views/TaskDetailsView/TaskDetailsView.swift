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
    @Binding var refreshTaskList: Bool
    @State var showDeleteAlert: Bool = false
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
                       
                        
                        showDeleteAlert.toggle()
                        
                        print("delete taskksks")
                       
                    } label: {
                        Text("Delete")
                            .fontWeight(.bold)
                            .foregroundStyle(.red)
                            .frame(maxWidth: .infinity, alignment: .center)
                    }.alert("Delete Task",
                            isPresented: $showDeleteAlert) {
                        Button(role: .destructive) {
                            taskViewModel.deleteTask(task: selectedTask)
                            refreshTaskList.toggle()
                            showTaskDetailsView.toggle()
                        } label: {
                            Text("Yes")
                                .foregroundStyle(.red)
                        }
                        Button {
                            showDeleteAlert.toggle()
                        } label: {
                            Text("No")
                        }


                    } message: {
                        Text("Do you want to really Delete task ?")
                            .foregroundStyle(.blue)
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
                            taskViewModel.updateTask(task: selectedTask)
                            refreshTaskList.toggle()
                            print("Update button tapped")
                            print(selectedTask.name)
                            print(selectedTask.description)
                            print(selectedTask.isCompleted)
                        } label: {
                            Text("Update")
                        }.disabled(selectedTask.name.isEmpty)

                    }
                    
                }
        }
    }
}
