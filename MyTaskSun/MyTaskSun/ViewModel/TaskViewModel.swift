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
    func updateTask(task: Task) -> Bool {
        if let taskIndex = tempTasks.firstIndex(where: {obj in obj.id == task.id}) {
            tempTasks[taskIndex].name = task.name
            tempTasks[taskIndex].description = task.description
            tempTasks[taskIndex].isCompleted = task.isCompleted
            tempTasks[taskIndex].finishDate = task.finishDate
            
            return true
        }
        return false
    }
    
    func deleteTask(task: Task) -> Bool {
        if let index = tempTasks.firstIndex(where: { $0.id == task.id }) {
            tempTasks.remove(at: index)
            return true
        }
        return false
    }
}
