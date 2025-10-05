//
//  ContentView.swift
//  04-BetterSleep
//
//  Created by Sayed on 04/10/25.
//

import SwiftUI

struct ContentView: View {
   
    var body: some View {
      Text("KK")
            
    }
}


struct PracticeComponents: View {
    @State private var sleepAmount: Double = 8
    @State private var wakeUp = Date.now
    var body: some View {
        Stepper("\(sleepAmount.formatted()) hours", value: $sleepAmount, in: 4...12, step: 0.25)
        DatePicker("Please enter a date", selection: $wakeUp)
        DatePicker("Please enter a date", selection: $wakeUp)
            .labelsHidden()
        DatePicker("Please enter a date", selection: $wakeUp, displayedComponents: .hourAndMinute)
            .labelsHidden()
        DatePicker("Please enter a date", selection: $wakeUp, in: Date.now...)
    }
}

#Preview {
    ContentView()
}
