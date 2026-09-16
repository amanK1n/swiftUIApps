//
//  VehicleDetailView.swift
//  SimpleEnergy_Aman
//
//  Created by comviva on 13/09/26.
//

import SwiftUI

struct VehicleDetailView: View {
    @StateObject private var viewModel: VehicleDetailViewModel

    init(vehicleId: Int) {
        _viewModel = StateObject(wrappedValue: VehicleDetailViewModel(vehicleId: vehicleId))
    }

    var body: some View {
        Group {
            if viewModel.isLoading && viewModel.vehicle == nil {
                ProgressView("Loading vehicle...")
            } else if let vehicle = viewModel.vehicle {
                ScrollView {
                    if let error = viewModel.errorMessage {
                        Text(error)
                            .font(.footnote)
                            .foregroundStyle(.red)
                            .padding()
                    }
                    headerSection(for: vehicle)
                    statsGrid(for: vehicle)
                    lastUpdatedSection(for: vehicle)
                }
                .navigationTitle(vehicle.name)
                .navigationBarTitleDisplayMode(.inline)
                .refreshable {
                    await viewModel.loadVehicle()
                }
            } else {
                if #available(iOS 17.0, *) {
                    ContentUnavailableView("Vehicle not found", systemImage: "car")
                } else {
                    // Fallback on earlier versions
                }
            }
        }
        .task {
            await viewModel.loadVehicle()
        }
    }

    private func headerSection(for vehicle: Vehicle) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(vehicle.model)
                .font(.title2)
                .foregroundStyle(.secondary)
            Text(vehicle.status)
                .font(.caption)
                .fontWeight(.semibold)
                .padding(.horizontal, 10)
                .padding(.vertical, 5)
                .background(vehicle.statusColor.opacity(0.15))
                .foregroundStyle(vehicle.statusColor)
                .clipShape(Capsule())
        }
    }

    private func statsGrid(for vehicle: Vehicle) -> some View {
        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
            statCard(title: "Battery", value: "\(vehicle.battery)%", icon: "battery.100", color: vehicle.batteryColor)
            statCard(title: "Range", value: "\(vehicle.range) km", icon: "road.lanes", color: .blue)
            statCard(title: "Speed", value: "\(vehicle.speed) km/h", icon: "speedometer", color: .orange)
            statCard(title: "Odometer", value: "\(vehicle.odometer) km", icon: "gauge.with.dots.needle.67percent", color: .purple)
        }
    }

    private func statCard(title: String, value: String, icon: String, color: Color) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Label(title, systemImage: icon)
                .font(.caption)
                .foregroundStyle(.secondary)
            Text(value)
                .font(.title3)
                .fontWeight(.semibold)
                .foregroundStyle(color)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }

    private func lastUpdatedSection(for vehicle: Vehicle) -> some View {
        HStack {
            Image(systemName: "clock")
                .foregroundStyle(.secondary)
            Text("Last updated: \(vehicle.lastUpdated.formatted(date: .abbreviated, time: .shortened))")
                .font(.footnote)
                .foregroundStyle(.secondary)
        }
    }
}
