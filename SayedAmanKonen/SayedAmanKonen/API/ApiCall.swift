//
//  ApiCall.swift
//  SayedAmanKonen
//
//  Created by comviva on 01/09/26.
//

import Foundation
import SwiftUI
import Combine
//struct ApiCall {
//    @Binding var apiResponse: [String:Any]
//    func callArticleAPI() {
//        let session = URLSession.shared
//        let urlString = URL(string: "https://alkyetest-738240239910.us-central1.run.app/myapp/list/")
//        
//        let task = session.dataTask(with: urlString!) { (data, response, error) in
//            if let error = error {
//                debugPrint(error.localizedDescription)
//                return
//            }
//            guard let response = response as? HTTPURLResponse else { return }
//            if response.statusCode == 200 {
//                let result = try? JSONSerialization.jsonObject(with: data ?? Data(), options: .mutableContainers)
//                DispatchQueue.main.async {
//                    apiResponse = result as? [String : Any] ?? [:]
//                    print("\(apiResponse)")
//                }
//            }
//        }
//        task.resume()
//        
//        
//        //
//    }
//}


// MARK: - Data Models
struct Article: Identifiable, Codable {
    let id: Int
    let title: String
    let created_at: String
    let prompt: String
    let short_description: String
    let content: String
    let image_url: String
}
 
struct APIResponse: Codable {
    let results: [Article]?
//    let articles: [Article]? // Try both possible response formats
//    
//    var allArticles: [Article] {
//        results ?? articles ?? []
//    }
}
 
// MARK: - Solution 1: Using Codable (BEST PRACTICE)
class ArticleViewModel: ObservableObject {
    @Published var articles: [Article] = []
    @Published var isLoading = false
    @Published var errorMessage: String? = nil
   // @Binding var articleResp: [Article]
    func callArticleAPI() {
        isLoading = true
        errorMessage = nil
        
        let urlString = "https://alkyetest-738240239910.us-central1.run.app/myapp/list/"
        guard let url = URL(string: urlString) else {
            errorMessage = "Invalid URL"
            isLoading = false
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                self.isLoading = false
                
                // Handle network error
                if let error = error {
                    self.errorMessage = error.localizedDescription
                    debugPrint("Network Error: \(error.localizedDescription)")
                    return
                }
                
                // Check response status code
                guard let httpResponse = response as? HTTPURLResponse else {
                    self.errorMessage = "Invalid response"
                    return
                }
                
                if httpResponse.statusCode != 200 {
                    self.errorMessage = "Status Code: \(httpResponse.statusCode)"
                    return
                }
                
                // Decode JSON
                guard let data = data else {
                    self.errorMessage = "No data received"
                    return
                }
                
                do {
                    let decoder = JSONDecoder()
                    let apiResponse = try decoder.decode([Article].self, from: data)
//                    self.articles = apiResponse.articles.map({ obj in
//                        Article(id: obj.id, title: obj.title, created_at: obj.created_at, prompt: obj.prompt, short_description: obj.short_description, content: obj.content, image_url: obj.image_url)
//                    })
                    print("\(apiResponse)")
                    self.articles = apiResponse
                } catch {
                    self.errorMessage = "Decode error: \(error.localizedDescription)"
                    debugPrint("Decoding Error: \(error)")
                }
            }
        }.resume()
    }
}
