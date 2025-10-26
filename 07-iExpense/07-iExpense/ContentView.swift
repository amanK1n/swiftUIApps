//
//  ContentView.swift
//  07-iExpense
//
//  Created by Sayed on 26/10/25.
//

import SwiftUI

struct ContentView: View {
    @State private var user = User()
    
    var body: some View {
        VStack {
            Text("Your name is \(user.fname) \(user.lname)")
            TextField("Your First name", text: $user.fname)
            TextField("Your Last name", text: $user.lname)
        }.padding()
    }
}



//struct User {
//    var fname = "Bilbo"
//    var lname = "Baggins"
//}
@Observable // Class with observable to observe the changes..
class User {
    var fname = "Bilbo"
    var lname = "Baggins"
}



struct FirstScreen: View {
    @State private var showNXTScreen: Bool = false
    var body: some View {
        Button("Present NXT screen") {
            showNXTScreen.toggle()
        }
        .sheet(isPresented: $showNXTScreen) {
            SecondScreen()
        }
    }
}

struct SecondScreen: View {
    @Environment(\.dismiss) var dismiss
    var body: some View {
        Text("Second screen")
        Button("Tap me to dismiss this screen!") {
            dismiss()
        }
    }
}

#Preview {
    ContentView()
}
