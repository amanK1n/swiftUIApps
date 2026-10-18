//
//  TaskDetailsView.swift
//  MyTaskSun
//
//  Created by comviva on 18/10/26.
//

import SwiftUI
struct TaskDetailsView: View {
    @ObservedObject var taskViewModel: TaskViewModel
    @Binding var showTaskDetailsView: Bool
    @Binding var selectedTask: Task
    @Binding var refreshList: Bool
    @State var deleteAlert: Bool = false
    var body: some View {
        NavigationStack {
            List {
                Section(header: Text("Task Details")) {
                    TextField("Task Name", text: $selectedTask.name)
                    TextEditor(text: $selectedTask.description)
                    Toggle("Mark Complete", isOn: $selectedTask.isCompleted)
                }
                Section(header: Text("Time / Date")) {
                    DatePicker("Pick Date & Time", selection: $selectedTask.finishDate)
                }
                Section {
                    Button {
                       
                        deleteAlert.toggle()
                       
                        
                    } label: {
                        Text("DELETE")
                            .foregroundStyle(.red)
                            .fontWeight(.black)
                            .frame(maxWidth: .infinity, alignment: .center)
                    }.alert("Do you really delete it?", isPresented: $deleteAlert) {
                        Button(role: .destructive) {
                            taskViewModel.deleteTask(task: selectedTask)
                            showTaskDetailsView.toggle()
                            refreshList.toggle()
                            
                        } label: {
                            Text("Delete")
                                .foregroundStyle(.red)
                                .fontWeight(.bold)
                        }
                        
                        Button {
                            deleteAlert.toggle()
                        } label: {
                            Text("No can do's will!!")
                                
                        }


                    }

                }
                
            }.navigationTitle("Task Details")
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button {
                            print("Update task")
                            taskViewModel.updateTask(task: selectedTask)
                            showTaskDetailsView.toggle()
                            refreshList.toggle()
                        } label: {
                            Text("Update")
                                .foregroundStyle(.purple)
                                .fontWeight(.black)
                        }.disabled(selectedTask.name.isEmpty)
                    }
                    
                    ToolbarItem(placement: .topBarLeading) {
                        Button {
                            print("Cancel task")
                            
                            showTaskDetailsView.toggle()
                            refreshList.toggle()
                        } label: {
                            Text("Cancel")
                                .foregroundStyle(.brown)
                                .fontWeight(.heavy)
                        }
                    }
 
                }
        }
    }
}
