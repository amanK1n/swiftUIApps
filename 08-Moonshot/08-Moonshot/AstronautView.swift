//
//  AstronautView.swift
//  08-Moonshot
//
//  Created by Sayed on 05/11/25.
//

import SwiftUI

struct AstronautView: View {
    var astronaut: Astronaut
    var body: some View {
        ScrollView {
            VStack {
                Image(astronaut.id)
                    .resizable()
                    .scaledToFit()
                
                Text(astronaut.description)
                    .font(.caption)
                    .padding()
            }
        }.background(.darkBackground)
            .navigationTitle(astronaut.name)
            .navigationBarTitleDisplayMode(.large)
    }
}

#Preview {
    let astronaut = Astronaut(id: "1", name: "Sayed", description: "Space")
    AstronautView(astronaut: astronaut)
}
