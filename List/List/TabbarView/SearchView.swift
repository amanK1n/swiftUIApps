//
//  SearchView.swift
//  List
//
//  Created by comviva on 30/08/26.
//

import Foundation
import SwiftUI
struct SearchView: View {
    var body: some View {
        VStack {
            Image(systemName: "magnifyingglass")
                .resizable()
                .frame(width: 50, height: 50, alignment: .center)
                .foregroundStyle(.pink)
            Text("SearchView")
                .font(.system(size: 40, weight: .heavy, design: .rounded))
                .foregroundStyle(.cyan)
        }
    }
}
