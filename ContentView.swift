//
//  ContentView.swift
//  AIChat
//
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var apiKeyInputViewModel = APIKeyInputViewModel()
    @ObservedObject var aiChatViewModel = AIChatViewModel()

    var body: some View {
        Group {
            if apiKeyInputViewModel.apiKeySubmitted {
                AIChatView(aiChatViewModel: aiChatViewModel)
            } else {
                APIKeyInputView(apiKeyInputViewModel: apiKeyInputViewModel)
            }
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
