//
//  BundleDecoder.swift
//  pracAppSun
//
//  Created by comviva on 03/10/26.
//

import Foundation

struct Landmark: Decodable {
    let landmarkId: Int
    let name, photo, description: String
}

struct City: Decodable {
    let cityId: Int
    let name: String
    let landmarks: [Landmark]
}

struct IPLTeams: Decodable {
    let id: Int
    let name: String
    let winners: String
    let icon: String
}






struct BundleDecoder {
    static func decodeLandmarkJSON() -> [City] {
        let json = Bundle.main.path(forResource: "landmarks", ofType: "json")
        let landmark = try! Data(contentsOf: URL(fileURLWithPath: json!) , options: .alwaysMapped)
        let city = try! JSONDecoder().decode([City].self, from: landmark)
        
        return city
    }
    
    
    static func decodeIPLJSON() -> [IPLTeams] {
        let jsonPath = Bundle.main.path(forResource: "iplTeams", ofType: "json")
        let iplTeamsResp = try! Data(contentsOf: URL(fileURLWithPath: jsonPath!) , options: .alwaysMapped)
        let iplTeams = try! JSONDecoder().decode([IPLTeams].self, from: iplTeamsResp)
        
        return iplTeams
    }
    
}
