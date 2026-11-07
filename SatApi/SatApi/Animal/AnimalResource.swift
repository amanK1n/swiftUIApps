//
//  AnimalResource.swift
//  SatApi
//
//  Created by comviva on 07/11/26.
//

import Foundation


struct AnimalResponse: Decodable {
    let errorMessage: String?
    let animals: [AnimalModel]?
  
    enum CodingKeys: String, CodingKey {
        case errorMessage
        case animals = "data"
    }
}

struct AnimalModel: Decodable {
    let name: String?
    let image: String?
}
struct AnimalResource {
    
    func getAnimals(completionHandler: @escaping(AnimalResponse?) -> ()) {
        let urlString = "https://api-dev-scus-demo.azurewebsites.net/api/Animal/GetAnimals"
        let url = URL(string: urlString)!
        let urlRequest = URLRequest(url: url)
        
        let session = URLSession.shared
        session.dataTask(with: urlRequest) { data, response, error in
            
            if let error = error {
                print("Error")
                return
            }
            
            guard let response = response as? HTTPURLResponse else {
                print()
                return
            }
            switch response.statusCode {
            case (200...203):
                print("Succes")
                do {
                    let jsonData = try JSONDecoder().decode(AnimalResponse.self, from: data!)
                    completionHandler(jsonData)
                } catch let error {
                    print(error)
                }
            case 401:
                print("Un-auth")
            default:
                print("")
            }
            
        }.resume()
        
        
    }
    
    
}
