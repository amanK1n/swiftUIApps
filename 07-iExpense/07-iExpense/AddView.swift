//
//  AddView.swift
//  07-iExpense
//
//  Created by Sayed on 28/10/25.
//

import SwiftUI
struct AddView: View {
    @State private var name = ""
    @State private var type = "Personal"
    @State private var amount = 0.0
    
    let types = ["Business", "Personal"]
    
    var body: some View {
        NavigationStack {
            Form {
                TextField("Entrare ur name", text: $name)
                
                Picker("Type", selection: $type) {
                    ForEach(types, id: \.self) {
                        Text($0)
                    }
                }
                
                TextField("Enter amount", value: $amount, format: .currency(code: "USD"))
                    .keyboardType(.decimalPad)
                
            }.navigationTitle("Add new expense")
        }
    }
}
