//
//  HomeView.swift
//  MyTaskSun
//
//  Created by comviva on 18/10/26.
//

import SwiftUI

struct HomeView: View {
    @StateObject var taskViewModel: TaskViewModel = TaskViewModel()
    @State private var segmentFilter: [String] = ["Active", "Completed"]
    @State private var defaultSegmentSelection: String = "Active"
    @State private var showAddTaskView: Bool = false
    @State private var showTaskDetailsView: Bool = false
    @State private var selectedTask: Task = Task(id: 0, name: "", description: "", isCompleted: false, finishDate: Date())
    @State private var refreshList: Bool = false
    var body: some View {
        NavigationStack {
            
            Picker("Picker", selection: $defaultSegmentSelection) {
                ForEach(segmentFilter, id: \.self) {
                    Text($0)
                }
            }.pickerStyle(.segmented)
                .onChange(of: defaultSegmentSelection) { oldValue, newValue in
                    taskViewModel.getTasks(isCompleted: defaultSegmentSelection == "Active")
                }
            
            List(taskViewModel.tasks, id: \.id) { task in
                VStack(alignment: .leading) {
                    Text(task.name)
                        .font(.title)
                    HStack {
                        Text(task.description).lineLimit(2)
                            .font(.subheadline)
                        Spacer()
                        Text("\(task.finishDate.toDateString())")
                            .font(.footnote)
                    }
                }.onTapGesture {
                    showTaskDetailsView.toggle()
                    selectedTask = task
                }
                .onChange(of: refreshList) { oldValue, newValue in
                    taskViewModel.getTasks(isCompleted: defaultSegmentSelection == "Active")
                }
                
               
            }.navigationTitle("Home")
                .listStyle(.plain)
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button {
                            debugPrint("Add new task")
                            showAddTaskView.toggle()
                        } label: {
                            Image(systemName: "plus")
                        }

                    }
                }
                .sheet(isPresented: $showAddTaskView) {
                    AddTaskView(taskViewModel: taskViewModel, showAddTaskView: $showAddTaskView, refreshList: $refreshList)
                }
                .sheet(isPresented: $showTaskDetailsView) {
                    TaskDetailsView(showTaskDetailsView: $showTaskDetailsView, selectedTask: $selectedTask)
                }
        }.onAppear {
            taskViewModel.getTasks(isCompleted: defaultSegmentSelection == "Active")
        }
        
    }
}
