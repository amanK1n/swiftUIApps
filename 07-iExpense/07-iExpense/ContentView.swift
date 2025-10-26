//
//  ContentView.swift
//  07-iExpense
//
//  Created by Sayed on 26/10/25.
//

import SwiftUI
import Observation

struct ContentView: View {
    var body: some View {
        Text("")
    }
}

struct User2: Codable {
    let firstName: String
    let lastName: String
}

struct CodeableDemo: View {
    @State private var user = User2(firstName: "Taylor", lastName: "Swift")
    var body: some View {
        Button("Save User") {
            let encoder = JSONEncoder()

            if let data = try? encoder.encode(user) {
                UserDefaults.standard.set(data, forKey: "UserData")
            }
        }
    }
}

struct AppStorDemo: View {
    @AppStorage("tapCount") private var count = 0
    var body: some View {
        Button("Tap:=--> \(count)") {
            count += 1
        }
    }
}

struct UserDefStore: View {
    @State private var count = UserDefaults.standard.integer(forKey: "tap")
    var body: some View {
        Button("Tap:=--> \(count)") {
            count += 1
            UserDefaults.standard.set(count, forKey: "tap")
        }
    }
}

struct AddDelRow: View {
    @State private var numbers: [Int] = [Int]()
    @State private var currentNumber: Int = 1
    var body: some View {
        NavigationStack {
            VStack {
                List {
                    ForEach(numbers, id: \.self) {
                        Text("Row: \($0)")
                    }
                    .onDelete(perform: removeRow)
                }
                
                
                Button("Add number!") {
                    numbers.append(currentNumber)
                    currentNumber += 1
                }
            }.toolbar {
                EditButton()
            }
        }
    }
    func removeRow(at: IndexSet) {
        numbers.remove(atOffsets: at)
    }
}


struct ObsExample: View {
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
