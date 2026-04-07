//
//  APIKeyManager.swift
//  AutoQA
//
//  Created by Sayed on 07/04/26.
//

import Foundation
class APIKeyManager {
    
    private static let key = "gemini_api_key"
    
    static func save(_ apiKey: String) {
        UserDefaults.standard.set(apiKey, forKey: key)
    }
    
    static func get() -> String? {
        return UserDefaults.standard.string(forKey: key)
    }
    
    static func isAvailable() -> Bool {
        return get()?.isEmpty == false
    }
}
