//
//  Untitled.swift
//  MyTask
//
//  Created by comviva on 11/10/26.
//

import Foundation
public import Combine

final class TaskViewModel: ObservableObject {
    @Published var tasks: [Task] = []
    var tempTask = Task.createMockTasks()
    func getTasks(isActive: Bool) {
        tasks = tempTask.filter({ obj in
            obj.isCompleted == !isActive
        })
    }
    
    func addTask(task: Task) -> Bool {
        let randId = Int.random(in: 4...100)
        let task = Task(id: randId,
                        name: task.name,
                        description: task.description,
                        isCompleted: task.isCompleted,
                        finishDate: task.finishDate)
        tempTask.append(task)
        return true
    }
    func updateTask(task: Task) -> Bool {
        if let index = tempTask.firstIndex(where: {$0.id == task.id}) {
            tempTask[index].name = task.name
            tempTask[index].description = task.description
            tempTask[index].finishDate = task.finishDate
            tempTask[index].isCompleted = task.isCompleted
            
            return true
        }
        return false
    }
    
    func deleteTask(task: Task) -> Bool {
        if let index = tempTask.firstIndex(where: {$0.id == task.id}) {
            tempTask.remove(at: index)
            return true
        }
        return false
    }
    
}
