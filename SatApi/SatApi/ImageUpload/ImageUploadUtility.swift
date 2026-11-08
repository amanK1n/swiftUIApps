//
//  ImageUploadUtility.swift
//  SatApi
//
//  Created by comviva on 08/11/26.
//

import Foundation

struct ImageUploadUtility {
    
    func postAPIData<T:Decodable>(requestUrl: URL, requestBody: Data, responseBody: T.Type, completionHandler: @escaping(_ result: T) -> () ) {
        var urlRequest = URLRequest(url: requestUrl)
        
        urlRequest.httpMethod = "post"
        urlRequest.httpBody = requestBody
        urlRequest.addValue("application/json", forHTTPHeaderField: "content-type")
        
        URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            if let error = error {
                debugPrint("error:\(error.localizedDescription)")
                return
            }
            
            guard let response = response as? HTTPURLResponse else {
                debugPrint("response failed")
                return
            }
            dump(error)
            print("================++>>>>>>>>>>>>>>>>>>")
            dump(response)
            print("================++>>>>>>>>>>>>>>>>>>")
            print(response.statusCode)
            print("================++>>>>>>>>>>>>>>>>>>")
            dump(data)
            switch response.statusCode {
            case (200...203):
                print("sucess")
                do {
                    let jsonData = try JSONDecoder().decode(responseBody.self, from: data!)
                    debugPrint("Image uploaded in ImageUploadUtility")
                    completionHandler(jsonData)
                } catch let error {
                    debugPrint(error)
                }
            case 401:
                print("Un-auth")
            default:
                print("failed in default")
            }
            
        }.resume()
        
    }
}
