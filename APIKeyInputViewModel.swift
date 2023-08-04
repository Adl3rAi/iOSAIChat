//
//  APIKeyInputViewModel.swift
//  AIChat
//
//

import SwiftUI

class APIKeyInputViewModel: ObservableObject {
    @Published var userInput: String = ""
    @Published var apiKeySubmitted: Bool = false
    private let apiKeyInputService = APIKeyInputService()
    
    func submitAPIKey() {
        apiKeyInputService.inputAPIKey(userInput)
        apiKeySubmitted = true
    }
}


