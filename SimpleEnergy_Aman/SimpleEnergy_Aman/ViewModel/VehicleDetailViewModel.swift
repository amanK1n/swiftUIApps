//
//  VehicleDetailViewModel.swift
//  SimpleEnergy_Aman
//
//  Created by comviva on 13/09/26.
//

import Foundation
internal import Combine

@MainActor
final class VehicleDetailViewModel: ObservableObject {
    @Published var vehicle: Vehicle?
    @Published var isLoading = false
    @Published var errorMessage: String?

    private let vehicleId: Int
    private let service: VehicleServiceProtocol

    init(vehicleId: Int, service: VehicleServiceProtocol = VehicleService()) {
        self.vehicleId = vehicleId
        self.service = service
    }

    func loadVehicle() async {
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }

        do {
            let vehicles = try await service.fetchVehicles()
            vehicle = vehicles.first(where: { $0.id == vehicleId })
            if vehicle == nil {
                errorMessage = "Vehicle not found"
            }
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
