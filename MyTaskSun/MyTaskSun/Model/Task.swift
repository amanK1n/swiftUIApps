//
//  Task.swift
//  MyTaskSun
//
//  Created by comviva on 18/10/26.
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
            Task(id: 1, name: "Learn Swift", description: "Learn something new", isCompleted: false, finishDate: Date()),
            Task(id: 2, name: "Learn DSA", description: "Practice DSA", isCompleted: false, finishDate: Date()),
            Task(id: 3, name: "Go to Gym", description: "Good for health", isCompleted: true, finishDate: Date()),
        ]
    }
    
}
