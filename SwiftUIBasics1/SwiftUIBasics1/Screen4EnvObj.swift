//
//  Screen4EnvObj.swift
//  SwiftUIBasics1
//
//  Created by comviva on 29/08/26.
//

import Foundation
import SwiftUI
import Combine

struct Screen4: View {
    @EnvironmentObject var emp: Employee
    var body: some View {
        VStack {
            Text("Screen 4")
            Text("Emp Name: \(emp.name)")
            TextField("Name", text: $emp.name)
            NavigationLink(destination: Screen4_1()) {
                Text("Go to Screen 4.1")
            }
        }
    }
}




struct Screen4_1: View {
    @EnvironmentObject var emp: Employee
    @EnvironmentObject var acc: Account
    var body: some View {
        VStack {
            Text("Screen 4.1")
            TextField("Enter code:", text: $emp.code)
            Stepper("Balance: \(acc.balance)", value: $acc.balance)
            NavigationLink("Navigate to 4.2", destination: Screen4_2())
        }
    }
}

struct Screen4_2: View {
    @EnvironmentObject var emp: Employee
    @EnvironmentObject var acc: Account
    var body: some View {
        VStack {
            Text("Screen 4.2")
            Text("Emp Name: \(emp.name), Emp code: \(emp.code), Balance: \(acc.balance)")
           
        }
    }
}


class Employee: ObservableObject {
    @Published var name: String = ""
    @Published var code: String = ""
}


public class Account: ObservableObject {
    @Published var balance: Double = 0.0
}
