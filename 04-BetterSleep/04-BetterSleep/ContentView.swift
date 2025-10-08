//
//  ContentView.swift
//  04-BetterSleep
//
//  Created by Sayed on 04/10/25.
//
import CoreML
import SwiftUI

struct ContentView: View {
    @State private var wakeUp = defaultWakeTime
    @State private var sleepAmount = 8.0
    @State private var coffeeAmount = 1
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    @State private var showAlert = false
    static var defaultWakeTime: Date {
        var components = DateComponents()
        components.hour = 7
        components.minute = 0
        return Calendar.current.date(from: components) ?? .now
    }
    var body: some View {
        NavigationStack {
            VStack {
                Text("When do you want to wake up?")
                    .font(.headline)

                DatePicker("Please enter a time", selection: $wakeUp, displayedComponents: .hourAndMinute)
                    .labelsHidden()

                Text("Desired amount of sleep")
                    .font(.headline)

                Stepper("\(sleepAmount.formatted()) hours", value: $sleepAmount, in: 4...12, step: 0.25)
                
                Text("Daily coffee intake")
                    .font(.headline)

                Stepper("\(coffeeAmount) cup(s)", value: $coffeeAmount, in: 1...20)
            }.navigationTitle("BetterRest")
                .toolbar {
                    Button("Calculate", action: calculateBedtime)
                }
                .alert(alertTitle, isPresented: $showAlert) {
                    Button("Ok") {}
                } message: {
                    Text(alertMessage)
                }
        }
            
    }
    func calculateBedtime() {
        print("Calal")
        do {
            print("Calal")
            let config = MLModelConfiguration()
            let model = try SleepCalc(configuration: config)
            let components = Calendar.current.dateComponents([.hour, .minute], from: wakeUp)
            let hour = (components.hour ?? 0) * 60 * 60
            let minute = (components.minute ?? 0) * 60
            let prediction = try model.prediction(wake: Double(hour + minute), estimatedSleep: Double(sleepAmount), coffee: Double(coffeeAmount))
            let sleepTime = wakeUp - prediction.actualSleep
            alertTitle = "Your ideal bedtime is: "
            alertMessage = sleepTime.formatted(date: .omitted, time: .shortened)
        } catch {
            print("Calal--9999")
            print("Error calculating bedtime:")
            print(error)
            alertTitle = "Error calculating bedtime:"
            alertMessage = error.localizedDescription
        }
        showAlert = true
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
