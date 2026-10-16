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
    
    func getTasks(isActive: Bool) {
        tasks = Task.createMockTasks().filter({ obj in
            obj.isCompleted == !isActive
        })
    }
}
