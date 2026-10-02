//
//  File5.swift
//  pracAppSun
//
//  Created by comviva on 27/09/26.
//
import SwiftUI
import Combine
class User5: ObservableObject {
    @Published var name: String = String()
}
class Account: ObservableObject {
    @Published var accountBalance: Double = 0.0
}
// This is First view of this module
struct File5: View {
    @EnvironmentObject var user: User5
   
    var body: some View {
        NavigationView {
            VStack {
                Text("Logged in Username: \(user.name)")
                TextField("Username", text: $user.name)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                NavigationLink("Nav to 2nd View") {
                    SecondView()
                }
            }.padding()
             .navigationBarTitle("Environment Object")
            
            
        }
    }
}

// This is Second View of this module
struct SecondView: View {
    @EnvironmentObject var account: Account
    var body: some View {
        Stepper("Account Balance: \(account.accountBalance)", value: $account.accountBalance)
        NavigationLink("Navigate to 3rd view", destination: ThirdView())
    }
    
    
    
}

// This is Third View of this module
struct ThirdView: View {
    @EnvironmentObject var user: User5
    @EnvironmentObject var account: Account
    var body: some View {
        Text("Third VIeew")
        Text("Logged In UserName = \(user.name) with balance = \(account.accountBalance)")
    }
}
