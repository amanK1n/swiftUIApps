//
//  ApiCall.swift
//  SimpleUIAPI
//
//  Created by comviva on 31/08/26.
//

import Foundation
import SwiftUI


struct ApiCallView: View {
    @Binding var result2: [String: Any]
    var body: some View {
        Button("2nd API Call") {
            apiCall()
        }
    }
    
    func apiCall() {
        let session = URLSession.shared
        guard let urlString = URL(string: "https://jsonplaceholder.typicode.com/todos/1") else {return}
        let task = session.dataTask(with: urlString) { (data, response, error) in
            if let error = error {
                return
            }
            guard let response = response as? HTTPURLResponse else {return}
            if response.statusCode == 200 {
                let data2 = try? JSONSerialization.jsonObject(with: data ?? Data(), options: .mutableContainers)
                self.result2 = data2 as! [String:Any]
            }
        }
        task.resume()
    }
}
