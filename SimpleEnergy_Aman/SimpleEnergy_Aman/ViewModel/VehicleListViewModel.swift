//
//  VehicleListModel.swift
//  SimpleEnergy_Aman
//
//  Created by comviva on 12/09/26.
//

import Foundation
internal import Combine
@MainActor
final class VehicleListViewModel: ObservableObject {
    @Published var vehicles: [Vehicle] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    private let service: VehicleServiceProtocol
    init(service: VehicleServiceProtocol = VehicleService()) {
        self.service = service
    }
    func loadVehicles() async {
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }
        do {
            vehicles = try await service.fetchVehicles()
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
}
