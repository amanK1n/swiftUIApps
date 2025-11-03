//
//  _8_MoonshotApp.swift
//  08-Moonshot
//
//  Created by Sayed on 29/10/25.
//

import SwiftUI

@main
struct _8_MoonshotApp: App {
    var body: some Scene {
        WindowGroup {
            let mission: [Mission] = Bundle.main.decode("missions.json")
            return MissionView(mission: mission[0])
                .preferredColorScheme(.dark)
        }
    }
}
