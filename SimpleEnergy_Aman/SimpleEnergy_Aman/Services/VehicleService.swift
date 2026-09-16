//
//  VehicleService.swift
//  SimpleEnergy_Aman
//
//  Created by comviva on 12/09/26.
//

import Foundation

enum APIConfig {
    static let vehiclesURL = URL(string: "https://raw.githubusercontent.com/amanK1n/SimpleEnergy/main/SimpleEnergy_Aman/SimpleEnergy_Aman/Resource/vehicles.json")!
}

enum VehicleError: LocalizedError {
    case invalidURL
    case invalidResponse
    case decodingFailed
    case bundleResourceMissing
    
    var errorDescription: String? {
        switch self {
        case .invalidURL: return "Invalid API URL"
        case .invalidResponse: return "Server returned an error"
        case .decodingFailed: return "Failed to parse vehicle data"
        case .bundleResourceMissing: return "Local vehicle data not found"
        }
    }
}

protocol VehicleServiceProtocol {
    func fetchVehicles() async throws -> [Vehicle]
}

final class VehicleService: VehicleServiceProtocol {
    private let session: URLSession
    private let decoder: JSONDecoder
    
    init(session: URLSession = .shared) {
        self.session = session
        self.decoder = JSONDecoder()
        self.decoder.dateDecodingStrategy = .custom { decoder in
            let container = try decoder.singleValueContainer()
            let string = try container.decode(String.self)
            let formatter = DateFormatter()
            formatter.locale = Locale(identifier: "en_US_POSIX")
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
            guard let date = formatter.date(from: string) else {
                throw DecodingError.dataCorruptedError(
                    in: container, debugDescription: "Invalid date: \(string)"
                )
            }
            return date
        }
    }
    func fetchVehicles() async throws -> [Vehicle] {
        do {
            return try await fetchFromRemote()
        } catch {
            return try loadFromBundle()
        }
    }

    private func fetchFromRemote() async throws -> [Vehicle] {
        let (data, response) = try await session.data(from: APIConfig.vehiclesURL)
        guard let http = response as? HTTPURLResponse,
              (200...299).contains(http.statusCode) else {
            throw VehicleError.invalidResponse
        }
        print("Fetched data")
        return try decodeVehicles(from: data)
    }

    private func loadFromBundle() throws -> [Vehicle] {
        guard let url = Bundle.main.url(forResource: "vehicles", withExtension: "json") else {
            throw VehicleError.bundleResourceMissing
        }
        let data = try Data(contentsOf: url)
        return try decodeVehicles(from: data)
    }

    private func decodeVehicles(from data: Data) throws -> [Vehicle] {
        do {
            return try decoder.decode([Vehicle].self, from: data)
        } catch {
            throw VehicleError.decodingFailed
        }
    }
}

