//
//  MissionView.swift
//  08-Moonshot
//
//  Created by Sayed on 03/11/25.
//

import SwiftUI

struct MissionView: View {
    struct CrewMember {
        let role: String
        let astronaut: Astronaut
    }
    let mission: Mission
    var crew: [CrewMember] = []
    var body: some View {
        ScrollView {
            VStack {
                Image(mission.image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200)
                Rectangle()
                    .frame(height: 2)
                    .foregroundStyle(.lightBackground)
                    .padding(.vertical)
                VStack(alignment: .leading) {
                    Text("Mission Highlights")
                        .font(.title.bold())
                        .padding(.bottom, 5)
                    Text(mission.description)
                    Rectangle()
                        .frame(height: 2)
                        .foregroundStyle(.lightBackground)
                        .padding(.vertical)
                    Text("Crew")
                        .font(.title.bold())
                        .padding(.bottom, 5)
                }.padding(.horizontal)
               
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(crew, id: \.role) { crewMember in
                            
                            NavigationLink {
                                Text("Assu details")
                            } label: {
                                
                                
                                HStack {
                                    Image(crewMember.astronaut.id)
                                        .resizable()
                                        .frame(width: 104, height: 72)
                                        .clipShape(.capsule)
                                        .overlay(
                                            Capsule()
                                                .strokeBorder(.white, lineWidth: 1)
                                        )
                                    astroNameView(crewMember: crewMember)
                                }.padding(.horizontal)
                            }
                        }
                    }
                }
            }.padding(.bottom )
        }.navigationTitle(mission.displayName)
            .navigationBarTitleDisplayMode(.inline)
            .background(.darkBackground)
    }
    
    func astroNameView(crewMember: CrewMember) -> some View {
       return VStack(alignment: .leading) {
            Text(crewMember.astronaut.name)
                .foregroundStyle(.white)
                .font(.headline)
            Text(crewMember.role)
                .foregroundStyle(.white.opacity(0.5))
                .font(.caption)
        }
    }
    
    init(mission: Mission, astronauts: [String: Astronaut]) {
        self.mission = mission
        self.crew = mission.crew.map { member in
            if let astronaut = astronauts[member.name] {
                return CrewMember(role: member.role, astronaut: astronaut)
            } else {
                fatalError("Missing \(member.name)")
            }
        }
    }
}

#Preview {
    let mission: [Mission] = Bundle.main.decode("missions.json")
    let astronauts: [String : Astronaut] = Bundle.main.decode("astronauts.json")
    MissionView(mission: mission[0], astronauts: astronauts)
        .preferredColorScheme(.dark)
}
