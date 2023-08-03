//
//  AIChatApp.swift
//  AIChat
//
//  Created by 胡卿元 on 2023/7/22.
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
