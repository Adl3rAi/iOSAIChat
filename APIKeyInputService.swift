//
//  APIKeyInputService.swift
//  AIChat
//
//  Created by 胡卿元 on 2023/8/1.
//

import Foundation
import KeychainAccess

struct APIKeyInputService {
    func inputAPIKey(_ api: String) {
        let keychain = Keychain(service: "aiadler.AIChat")
        do {
            try keychain.set(api, key: "OpenAIAPIKey")
        } catch let error {
            print("Error saving data: \(error)")
        }
    }
    
    func hasAPIKey() -> Bool {
        let keychain = Keychain(service: "aiadler.AIChat")
        do {
            let apiKey = try keychain.get("OpenAIAPIKey")
            return apiKey != nil
        } catch let error {
            print("Error fetching data: \(error)")
            return false
        }
    }
    
}
