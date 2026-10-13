//
//  HomeView.swift
//  MyTask
//
//  Created by comviva on 11/10/26.
//
import SwiftUI
struct HomeView: View {
    @ObservedObject var taskViewModel: TaskViewModel = TaskViewModel()
    @State private var pickerFilters: [String] = ["Active", "Closed"]
    @State private var defaultPickerSelectedItem: String = "Active"
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
                }
            }.onAppear {
                taskViewModel.getTasks(isActive: true)
            }.listStyle(.plain)
                .navigationTitle("Home")
        }
        
    }
    
    
    
}
