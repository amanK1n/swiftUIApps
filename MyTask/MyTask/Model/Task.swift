//
//  Task.swift
//  MyTask
//
//  Created by comviva on 11/10/26.
//
import Foundation
struct Task {
    let id: Int
    var name: String
    var description: String
    var isCompleted: Bool
    var finishDate: Date
    
    static func createMockTasks() -> [Task] {
        return [
                Task(id: 1, name: "Go to gym", description: "back workout", isCompleted: false, finishDate: Date()),
                Task(id: 2, name: "Car wash", description: "Downtown car wash center", isCompleted: false, finishDate: Date()),
                Task(id: 3, name: "Office work", description: "Finish picker module", isCompleted: true, finishDate: Date())
        ]
    }
}
