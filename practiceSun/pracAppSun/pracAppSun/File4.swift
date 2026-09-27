//
//  File4.swift
//  pracAppSun
//
//  Created by comviva on 27/09/26.
//
import SwiftUI
import Combine
struct File4: View {
    @State var name: String = ""
    @ObservedObject var user: User = User()
    var body: some View {
        Text("Hi my name is: \(user.name)")
        TextField("Enter your name", text: $user.name)
    }
}

class User: ObservableObject {
    @Published var name: String = ""
}
