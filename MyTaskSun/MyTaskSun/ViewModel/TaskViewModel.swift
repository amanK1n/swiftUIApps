//
//  TaskViewModel.swift
//  MyTaskSun
//
//  Created by comviva on 18/10/26.
//

import Combine
import Foundation

class TaskViewModel: ObservableObject {
    @Published var tasks: [Task] = []
    var tempTasks: [Task] = Task.createMockTasks()
    func getTasks(isCompleted: Bool) {
        tasks = tempTasks.filter({ obj in
            obj.isCompleted != isCompleted
        })
    }
    
    func addTask(task: Task) -> Bool {
        let randomId = Int.random(in: 4...100)
        let task = Task(id: randomId, name: task.name, description: task.description, isCompleted: task.isCompleted, finishDate: task.finishDate)
        tempTasks.append(task)
        
        return true
    }
    
    
}
