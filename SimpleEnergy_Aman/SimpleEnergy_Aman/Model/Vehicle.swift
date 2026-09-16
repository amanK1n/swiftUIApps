//
//  Vehicle.swift
//  SimpleEnergy_Aman
//
//  Created by comviva on 12/09/26.
//

import Foundation
import SwiftUI
struct Vehicle: Identifiable, Codable, Hashable {
    let id: Int
    let name: String
    let model: String
    let battery: Int
    let range: Int
    let speed: Int
    let odometer: Int
    let status: String
    let lastUpdated: Date

    enum CodingKeys: String, CodingKey {
        case id, name, model, battery, range, speed, odometer, status, lastUpdated
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        model = try container.decode(String.self, forKey: .model)
        battery = try container.decodeIfPresent(Int.self, forKey: .battery) ?? 0
        range = try container.decodeIfPresent(Int.self, forKey: .range) ?? 0
        speed = try container.decodeIfPresent(Int.self, forKey: .speed) ?? 0
        odometer = try container.decodeIfPresent(Int.self, forKey: .odometer) ?? 0
        status = try container.decodeIfPresent(String.self, forKey: .status) ?? ""
        lastUpdated = try container.decodeIfPresent(Date.self, forKey: .lastUpdated) ?? .distantPast
    }
}

extension Vehicle {
    var batteryColor: Color {
        switch battery {
        case 0..<20: return .red
        case 20..<50: return .orange
        default: return .green
        }
    }
    var statusColor: Color {
        status.uppercased() == "ONLINE" ? .green : .gray
    }
}
