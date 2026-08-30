//
//  BundleDecoder.swift
//  List
//
//  Created by comviva on 30/08/26.
//

import Foundation
struct BundleDecoder {
    static func getCityData() -> [City] {
        guard let url = Bundle.main.url(forResource: "landmarks", withExtension: "json") else {
            fatalError("Failed to locate landmarks.json in the app bundle.")
        }

        do {
            let data = try Data(contentsOf: url)
            return try JSONDecoder().decode([City].self, from: data)
        } catch {
            fatalError("Failed to decode landmarks.json: \(error)")
        }
    }
}
