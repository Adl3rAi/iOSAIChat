//
//  AIChatApp.swift
//  AIChat
//
//

import SwiftUI

@main
struct AIChatApp: App {
    private let aiChatViewModel = AIChatViewModel()
    private let apiKeyInputViewModel = APIKeyInputViewModel()
    var body: some Scene {
        WindowGroup {
           ContentView()
        }
    }
}
