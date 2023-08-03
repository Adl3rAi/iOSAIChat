//
//  APIKeyInputViewModel.swift
//  AIChat
//
//  Created by 胡卿元 on 2023/8/1.
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


