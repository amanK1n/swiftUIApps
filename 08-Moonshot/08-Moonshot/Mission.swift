//
//  Mission.swift
//  08-Moonshot
//
//  Created by Sayed on 30/10/25.
//

import Foundation
struct Mission: Codable, Identifiable {
    struct CrewRole: Codable {
        let name: String
        let role: String
    }
    let id: Int
    let launchDate: String?
    let description: String
    let crew: [CrewRole]
    
    var displayName: String {
        "Apollo \(id)"
    }
    var image: String {
        "apollo\(id)"
    }
    
}
