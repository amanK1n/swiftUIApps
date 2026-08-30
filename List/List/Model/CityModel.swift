//
//  LandmarksModel.swift
//  List
//
//  Created by comviva on 30/08/26.
//

import Foundation
struct City: Decodable {
    let cityId: Int
    let name: String
    let landmarks: [Landmark]
}

struct Landmark: Decodable {
    let landmarkId: Int
    let name,photo,description: String
}
