//
//  MyTaskApp.swift
//  MyTask
//
//  Created by comviva on 11/10/26.
//

import SwiftUI
import CoreData

@main
struct MyTaskApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            HomeView()
        }
    }
}
