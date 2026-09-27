//
//  File1.swift
//  pracAppSun
//
//  Created by comviva on 27/09/26.
//

import SwiftUI


struct File1: View {
    @State private var name: String = ""
    var body: some View {
        VStack {
            TextField("Enter your name", text: $name)
                .border(.blue)
                .padding()
                .frame(height: 40, alignment: .center)
                
           Button(action: {
               print("Btn tapped!!")
               print(name)
           }, label: {
               Text("Press ME!!")
                   .font(.headline)
                   .foregroundStyle(.black)
                   
                  
           }).padding(10)
           .background(.blue)
                .clipShape(.capsule)
        
        
        }
    }
}
