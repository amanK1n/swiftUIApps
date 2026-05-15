//
//  UItilityExplorer.swift
//  AIQATestRunner
//
//  Created by Sayed on 16/04/26.
//

import Foundation
import AppKit
func bootSimulator() {
    let task = Process()
    task.launchPath = "/usr/bin/xcrun"
    
    // Boot the default simulator (or specify a device ID)
//    task.arguments = ["simctl", "boot", "iPhone 15 Pro"]
    task.arguments = ["simctl", "boot", "A08BF600-DE5E-4518-A8B5-758014E2FCF0"]
    
    let pipe = Pipe()
    task.standardOutput = pipe
    task.standardError = pipe

    do {
        try task.run()
        task.waitUntilExit()

        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        if let output = String(data: data, encoding: .utf8) {
            print(output)
            openSimulatorApp()
        }
    } catch {
        print("Error booting simulator: \(error)")
    }
}
func openSimulatorApp() {
    let task = Process()
    task.launchPath = "/usr/bin/open"
    task.arguments = ["-a", "Simulator"]
    
    try? task.run()
}

func runAutomationRunner() {
    let task = Process()
    task.launchPath = "/bin/zsh"
    
    let command = """
    \(NSHomeDirectory())/.maestro/bin/maestro test --format html-detailed --output ~/Desktop/e2e/build/report.html ~/Desktop/e2e
    """
    
    task.arguments = ["-c", command]
    
    let pipe = Pipe()
    task.standardOutput = pipe
    task.standardError = pipe
    
    do {
        try task.run()
        
        // Read logs live
        pipe.fileHandleForReading.readabilityHandler = { handle in
            let data = handle.availableData
            if let output = String(data: data, encoding: .utf8), !output.isEmpty {
                print(output)
            }
        }
        
        task.terminationHandler = { process in
            print("Finished with code: \(process.terminationStatus)")
            
            // Open report automatically
            DispatchQueue.main.async {
                let path = "\(NSHomeDirectory())/Desktop/e2e/build/report.html"
                NSWorkspace.shared.open(URL(fileURLWithPath: path))
            }
        }
        
    } catch {
        print("Error: \(error)")
    }
}
