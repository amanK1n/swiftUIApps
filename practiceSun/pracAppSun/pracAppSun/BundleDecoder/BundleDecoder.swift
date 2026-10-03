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

struct BundleDecoder {
    static func decodeJSON() -> [City] {
        let json = Bundle.main.path(forResource: "landmarks", ofType: "json")
        let landmark = try! Data(contentsOf: URL(fileURLWithPath: json!) , options: .alwaysMapped)
        let city = try! JSONDecoder().decode([City].self, from: landmark)
        
        return city
    }
}
