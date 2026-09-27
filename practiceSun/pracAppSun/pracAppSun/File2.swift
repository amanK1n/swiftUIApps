//
//  File2.swift
//  pracAppSun
//
//  Created by comviva on 27/09/26.
//
import SwiftUI
struct File2: View {
    @State var username: String = ""
    @State var password: String = ""
    var body: some View {
        VStack {
            Text("Login")
                .font(.headline)
                .padding()
            Text("Explore SwiftUI with Aman")
                .font(.subheadline)
                .padding()
            TextField("Username", text: $username)
                .padding()
                .background(.gray)
                .cornerRadius(4.0)
            SecureField("Password", text: $password)
                .padding()
                .background(.gray)
                .cornerRadius(4.0)
            
            HStack {
                Button(action: {
                    debugPrint("Login btn tapped")
                }, label: {
                    Text("Login")
                })
                Spacer()
                Button {
                    debugPrint("Forgot tapped!!")
                } label: {
                    Text("Forgot Password!!")
                }

            }
        }.padding()
    }
}
