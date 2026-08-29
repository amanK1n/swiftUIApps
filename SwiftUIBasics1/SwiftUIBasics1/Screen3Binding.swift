//
//  Screen3Binding.swift
//  SwiftUIBasics1
//
//  Created by comviva on 29/08/26.
//

import Foundation
import SwiftUI

struct Screen3: View {
    @State private var isOn: Bool = false
    var body: some View {
        VStack {
            Text("Screen 3 Binding")
                .foregroundStyle(isOn ? .red : Color.secondary)
                .font(.headline)
                .padding()
           
            Screen3ChildViewToggle(isOn: $isOn)
           
            
        }
    }
}


struct Screen3ChildViewToggle: View {
    @Binding var isOn: Bool
    var body: some View {
        VStack {
            
            Toggle("Toggle", isOn: $isOn)
           
        }
    }
}

