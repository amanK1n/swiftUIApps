//
//  HomeView.swift
//  List
//
//  Created by comviva on 30/08/26.
//

import Foundation
import SwiftUI
struct HomeView: View {
    var body: some View {
        VStack {
            Image(systemName: "house")
                .resizable()
                .frame(width: 60, height: 50, alignment: .center)
                .foregroundStyle(.indigo)
            Text("Home Screen")
                .font(.system(size: 30, weight: .black, design: .monospaced))
                .foregroundStyle(.purple)
        }
    }
}
