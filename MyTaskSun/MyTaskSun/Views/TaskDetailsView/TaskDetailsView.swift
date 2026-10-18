//
//  TaskDetailsView.swift
//  MyTaskSun
//
//  Created by comviva on 18/10/26.
//

import SwiftUI
struct TaskDetailsView: View {
    @Binding var showTaskDetailsView: Bool
    @Binding var selectedTask: Task
    var body: some View {
        NavigationStack {
            List {
                Section(header: Text("Task Details")) {
                    TextField("Task Name", text: $selectedTask.name)
                    TextEditor(text: $selectedTask.description)
                }
                Section(header: Text("Time / Date")) {
                    DatePicker("Pick Date & Time", selection: $selectedTask.finishDate)
                }
            }.navigationTitle("Task Details")
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button {
                            print("Update task")
                            showTaskDetailsView.toggle()
                        } label: {
                            Text("Update")
                                .foregroundStyle(.purple)
                                .fontWeight(.black)
                        }
                    }
                    
                    ToolbarItem(placement: .topBarLeading) {
                        Button {
                            print("Cancel task")
                            showTaskDetailsView.toggle()
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
