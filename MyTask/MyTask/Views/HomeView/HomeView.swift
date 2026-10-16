//
//  HomeView.swift
//  MyTask
//
//  Created by comviva on 11/10/26.
//
import SwiftUI
struct HomeView: View {
    @StateObject var taskViewModel: TaskViewModel = TaskViewModel()
    @State private var pickerFilters: [String] = ["Active", "Completed"]
    @State private var defaultPickerSelectedItem: String = "Active"
    @State private var showAddTaskView: Bool = false
    @State private var showTaskDetailsView: Bool = false
    @State private var selectedTask: Task = Task(id: 0, name: "", description: "", isCompleted: false, finishDate: Date())
    @State private var refreshTaskList: Bool = false
    var body: some View {
        NavigationStack {
            
            Picker("Picker filter", selection: $defaultPickerSelectedItem) {
                ForEach(pickerFilters, id: \.self) {
                    Text($0)
                }
            }.pickerStyle(.segmented)
             .onChange(of: defaultPickerSelectedItem) { a, b in
                    taskViewModel.getTasks(isActive: defaultPickerSelectedItem == "Active")
            }
            
            List(taskViewModel.tasks, id: \.id) { task in
                VStack(alignment: .leading) {
                    Text(task.name).font(.title)
                    HStack {
                        Text(task.description).lineLimit(2)
                            .font(.subheadline)
                        Spacer()
                        Text("\(task.finishDate.toString())")
                    }
                }.onTapGesture {
                    selectedTask = task
                    showTaskDetailsView.toggle()
                }
                .onChange(of: refreshTaskList) { a,b in
                    taskViewModel.getTasks(isActive: defaultPickerSelectedItem == "Active")
                }
                
            }.onAppear {
                taskViewModel.getTasks(isActive: defaultPickerSelectedItem == "Active")
            }.listStyle(.plain)
                .navigationTitle("Home")
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button {
                            showAddTaskView = true
                        } label: {
                            Image(systemName: "plus")
                        }

                    }
                }.sheet(isPresented: $showAddTaskView) {
                    AddTaskView(taskViewModel: taskViewModel, showAddTaskView: $showAddTaskView, refreshTaskList: $refreshTaskList)
                }
                .sheet(isPresented: $showTaskDetailsView) {
                    TaskDetailsView(taskViewModel: taskViewModel,
                                    showTaskDetailsView: $showTaskDetailsView,
                                    selectedTask: $selectedTask,
                                    refreshTaskList: $refreshTaskList)
                }
            
            
            
        }
        
    }
    
    
    
}
