//
//  PlayView.swift
//  List
//
//  Created by comviva on 30/08/26.
//

import Foundation
import SwiftUI

struct PlayView: View {
    var body: some View {
        VStack {
            Image(systemName: "play")
                .resizable()
                .frame(width: 50, height: 50, alignment: .center)
                .foregroundStyle(.ultraThinMaterial)
                .background(.purple)
            Text("Play")
                .font(.system(size: 40, weight: .ultraLight, design: .serif))
                .foregroundStyle(.link)
        }
    }
}
struct NotesView: View {
    var body: some View {
        VStack {
            Image(systemName: "pencil")
                .resizable()
                .frame(width: 50, height: 50, alignment: .center)
                .foregroundStyle(.cyan)
            Text("Notes")
                .font(.system(size: 40, weight: .ultraLight, design: .serif))
                .foregroundStyle(.link)
        }
    }
}
