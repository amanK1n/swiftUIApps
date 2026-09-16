//
//  VehicleRowView.swift
//  SimpleEnergy_Aman
//
//  Created by comviva on 13/09/26.
//

import Foundation
import SwiftUI

struct VehicleRowView: View {
    let vehicle: Vehicle
    var body: some View {
        HStack(spacing: 12) {
            VStack(alignment: .leading, spacing: 4) {
                Text(vehicle.name)
                    .font(.headline)
                Text(vehicle.model)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                Text("Range: \(vehicle.range) Km")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }
            Spacer()
            VStack(alignment: .trailing, spacing: 6) {
                Label("\(vehicle.battery)%", systemImage: "battery.100")
                    .font(.subheadline)
                    .foregroundStyle(vehicle.batteryColor)
                Text(vehicle.status)
                    .font(.caption)
                    .fontWeight(.semibold)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(vehicle.statusColor.opacity(0.15))
                    .foregroundStyle(vehicle.statusColor)
                    .clipShape(Capsule())
            }
            
        }.padding(.vertical, 4)
    }
    

}
