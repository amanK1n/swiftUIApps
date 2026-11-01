//
//  VCExtension.swift
//  SatApi
//
//  Created by comviva on 27/10/26.
//

import Foundation
struct EmployeeResponseModel: Decodable {
    let id: Int
    let name: String
    let role: String
    let joining: String
    let depid: Int
    let salary: Int
    let workPhone: String
}
extension ViewController {
    // VIDEO 4: Decodable in swift | JsonDecoder in swift 5 | parse json api swift 5 Hindi
    
    
    
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

// VIDEO 5: Write Clean code for JSON API parsing in swift
// GET GENERICS
// VIDEO 6: Clean code for JSON POST API request in swift with URLSession, Encodable & Generic
// POST GENERICS
struct HTTPUtility {
    func getApiData<T: Decodable>(requestURL: URL, resultType: T.Type ,completionHandler: @escaping(_ result: T) -> Void ) {
        URLSession.shared.dataTask(with: requestURL) { data, response, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            guard let response = response as? HTTPURLResponse else {
                print(response)
                return
            }
            
            switch response.statusCode {
            case (200...203):
                print("")
                do {
                    let jsonData = try JSONDecoder().decode(resultType, from: data ?? Data())
                    completionHandler(jsonData)
                } catch let error {
                    completionHandler(error as! T)
                    debugPrint(error.localizedDescription)
                }
                
            case 401:
                print("Un-authorized")
            default:
                print("error")
            }
            
        }.resume()
        
    }
    
    func getPostData<T: Decodable>(urlRequest: URLRequest, responseBody: T.Type, completionHandler: @escaping (_ result: T) -> Void) {
        let session = URLSession.shared
        session.dataTask(with: urlRequest) { data, response, error in
            if let error = error {
                dump(error)
                return
            }
            guard let response = response as? HTTPURLResponse else {
                debugPrint("Error in Response")
                return
            }
            switch response.statusCode {
            case (200...203):
                print("")
                do {
                    let jsonData = try JSONDecoder().decode(responseBody, from: data ?? Data())
                    completionHandler(jsonData)
                } catch let error {
                    debugPrint(error)
                }
            case 401:
                debugPrint("Error UN-AUTH")
            default:
                debugPrint("Error DEFAULT ERROR")
            }
        }.resume()
    }
}

extension ViewController {
    
    
    
    
    
    
    
    
    
}
