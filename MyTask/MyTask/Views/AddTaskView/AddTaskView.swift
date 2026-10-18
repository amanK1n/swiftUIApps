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
    @State private var showDirtyCheckAlert: Bool = false
    
    var pickerDateRange: ClosedRange<Date> {
        let calendar = Calendar.current
        let currentDateComponent = calendar.dateComponents([.day, .month, .year, .hour, .minute], from: Date())
        let startDateComponent = DateComponents(year: currentDateComponent.year, month: currentDateComponent.month, day: currentDateComponent.day, hour: currentDateComponent.hour, minute: currentDateComponent.minute)
        
        let endDateComponent = DateComponents(year: 2027, month: 12, day: 31)
        
        return calendar.date(from: startDateComponent)!...calendar.date(from: endDateComponent)!
        
    }
    
    
    var body: some View {
        NavigationStack {
            List {
                Section(header: Text("Task Details")) {
                    TextField("Task name", text: $taskToAdd.name)
                    TextEditor(text: $taskToAdd.description)
                }
                Section(header: Text("Task date/time")) {
                    DatePicker("Task date", selection: $taskToAdd.finishDate, in: pickerDateRange)
                }
            }.navigationTitle("Add Task")
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Button {
                            print("Cancel button tapped")
                            if (!taskToAdd.name.isEmpty) {
                                print("Show dirty alert")
                                showDirtyCheckAlert.toggle()
                            } else {
                                print("Dismiss Add task sheet")
                                showAddTaskView.toggle()
                            }
                            
                        } label: {
                            Text("Cancel")
                        }.alert("Save Task",
                                isPresented: $showDirtyCheckAlert) {
                            Button {
                                showAddTaskView.toggle()
                            } label: {
                                Text("Cancel")
                            }
                            Button {
                                addTask()
                            } label: {
                                Text("Save")
                            }


                        } message: {
                            Text("Would you like to save the task ?")
                        }

                    }
                    
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            print("Add button tapped")
                          
                            addTask()
                        } label: {
                            Text("Add")
                        }.disabled(taskToAdd.name.isEmpty)

                    }
                    
                }
        }
    }
    private func addTask() {
        taskViewModel.addTask(task: taskToAdd)
        refreshTaskList.toggle()
        showAddTaskView.toggle()
    }
    
}
struct AddTaskView_Previews: PreviewProvider {
    static var previews: some View {
        AddTaskView(taskViewModel: TaskViewModel(), showAddTaskView: .constant(false), refreshTaskList: .constant(false))
    }
}
