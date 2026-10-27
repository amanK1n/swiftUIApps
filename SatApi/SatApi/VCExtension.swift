//
//  VCExtension.swift
//  SatApi
//
//  Created by comviva on 27/10/26.
//

import Foundation

extension ViewController {
    // VIDEO 4: Decodable in swift | JsonDecoder in swift 5 | parse json api swift 5 Hindi
    
    struct EmployeeResponseModel: Decodable {
        let id: Int
        let name: String
        let role: String
        let joining: String
        let depid: Int
        let salary: Int
        let workPhone: String
    }
    
    func decodablePostApiCall() {
        let url = URL(string: Endpoint.employeesEndpoint)
        let session = URLSession.shared
        
        session.dataTask(with: url!) { data, response, error in
            if let error = error {
                print("Error: in error \(error.localizedDescription)")
                return
            }
            
            guard let response = response as? HTTPURLResponse else { return }
            
            switch response.statusCode {
            case (200...203):
                print("Success")
                do {
                    let jsonData = try JSONDecoder().decode(EmployeeResponseModel.self, from: data ?? Data())
                    print(jsonData.id)
                    print(jsonData.depid)
                    print(jsonData.joining)
                    print(jsonData.name)
                    print(jsonData.role)
                    print(jsonData.workPhone)
                    print(jsonData.salary)
                } catch let error {
                    debugPrint("Error in data decoding")
                    debugPrint(error.localizedDescription)
                }
            case 401:
                print("Un-authorized")
            default:
                print("Error in response")
            }
            
        }.resume()
    }
}
