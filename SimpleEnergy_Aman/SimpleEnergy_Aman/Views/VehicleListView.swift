//
//  VehicleListView.swift
//  SimpleEnergy_Aman
//
//  Created by Aman on 12/09/26.
//

import Foundation
import SwiftUI
struct VehicleListView: View {
    @StateObject private var viewModel = VehicleListViewModel()
    var body: some View {
        NavigationStack {
        Group {
            
            if viewModel.isLoading {
                ProgressView("Loading vehicles...")
            } else if let error = viewModel.errorMessage {
                VStack(spacing: 16) {
                    Image(systemName: "exclamationmark.triangle")
                        .font(.system(size: 48))
                        .foregroundStyle(.secondary)
                    Text("Error")
                        .font(.title2)
                        .fontWeight(.semibold)
                    Text(error)
                        .font(.body)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                    Button("Try Again") {
                        Task { await viewModel.loadVehicles() }
                    }
                    .buttonStyle(.borderedProminent)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                
                
            } else {
                List(viewModel.vehicles) { vehicle in
                    NavigationLink(value: vehicle) {
                        VehicleRowView(vehicle: vehicle)
                    }
                }
            }
            
            
        }.navigationTitle("Vehicle")
            .navigationDestination(for: Vehicle.self) { vehicle in
                VehicleDetailView(vehicleId: vehicle.id)
            }.task {
                await viewModel.loadVehicles()
            }
        
    }
        
    }
}
