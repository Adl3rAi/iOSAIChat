//
//  AIChatViewModel.swift
//  AIChat
//
//  Created by 胡卿元 on 2023/7/22.
//

import SwiftUI

class AIChatViewModel: ObservableObject {
    @Published private var aiChatModel = AIChatModel()
    private var apiKeyInputViewModel = APIKeyInputViewModel()
    private var aiChatService = AIChatService()
    @Published var allMessages: [chatAPIMessage] = [
        chatAPIMessage(role: "system", content: "You will be provided with information from AI")
    ]
    @AppStorage("language") var userLanguage: String = "English"
    
    var messages: [Message] {
        aiChatModel.messages
    }
    
    func handleVoiceInput(audioFileURL: URL) {
        aiChatService.speechToText(audioFileURL: audioFileURL) { [weak self] (text) in
            guard let text = text else {
                print("Error: Failed to convert voice to text")
                return
            }
            self?.handleTextInput(text: text)
        }
    }

    // Handle user's text input
    func handleTextInput(text: String) {
        aiChatModel.addNewUserMessage(content: text)
        allMessages.append(chatAPIMessage(role: "user", content: text))
        aiChatService.requestAIResponse(language: userLanguage, messages: allMessages) { [weak self] result in
            switch result {
            case .success(let aiText):
                DispatchQueue.main.async {
                    self?.aiChatModel.addNewAIMessage(content: aiText)
                    self?.allMessages.append(chatAPIMessage(role: "system", content: aiText))
                }
                self?.aiChatService.textToSpeech(text: aiText, language: self?.userLanguage ?? "English")
            case .failure(let error):
                print("Error: \(error)")
            }
        }
    }
    
    func playAudio(text: String, language: String) {
        aiChatService.textToSpeech(text: text, language: language)
    }
}

