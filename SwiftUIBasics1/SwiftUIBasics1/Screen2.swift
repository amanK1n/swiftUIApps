//
//  Screen2.swift
//  SwiftUIBasics1
//
//  Created by comviva on 28/08/26.
//

import Foundation
import SwiftUI

struct Screen2: View {
    @State private var username: String = String()
    @State private var password: String = String()
    var body: some View {
        VStack {
            Text("Login")
                .font(.largeTitle)
                .padding()
            Text("Learn SwiftUI Basics")
                .font(.subheadline)
                .padding()
            TextField("Username", text: $username)
                .padding()
                .background(Color.gray)
                .cornerRadius(5.0)
            SecureField("Password", text: $password)
                .padding()
                .background(Color.gray)
                .cornerRadius(5.0)
            
            HStack {
                Button(action: {
                 debugPrint("Login tapped!!")
                }, label: {
                    Text("Login")
                })
                Spacer()
                Button(action: {
                    debugPrint("Forogte Password?")
                }, label: {
                    Text("Forgot Password?")
                })
                
            }.padding()
        }.padding()
    }
}
