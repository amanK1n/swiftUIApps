//
//  MissionView.swift
//  08-Moonshot
//
//  Created by Sayed on 03/11/25.
//

import SwiftUI

struct MissionView: View {
    let mission: Mission
    
    var body: some View {
        ScrollView {
            VStack {
                Image(mission.image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200)
                VStack(alignment: .leading) {
                    Text("Mission Highlights")
                        .font(.title.bold())
                        .padding(.bottom, 5)
                    Text(mission.description)
                }.padding(.horizontal)
            }.padding(.bottom )
        }.navigationTitle(mission.displayName)
            .navigationBarTitleDisplayMode(.inline)
            .background(.darkBackground)
    }
}

#Preview {
    let mission: [Mission] = Bundle.main.decode("missions.json")
    return MissionView(mission: mission[0])
        .preferredColorScheme(.dark)
}
