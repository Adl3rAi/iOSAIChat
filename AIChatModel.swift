//
//  AIChatModel.swift
//  AIChat
//
//  Created by 胡卿元 on 2023/7/22.
//

import Foundation

struct Message: Identifiable, Equatable {
    let id : UUID
    let role: String
    let content: String
    let timestamp: Date
}

struct chatAPIMessage: Codable {
    let role: String
    let content: String
}

class AIChatModel: ObservableObject {
    var messages: [Message] = []

    func addNewUserMessage(content: String) {
        let message = Message(id: UUID(), role: "user", content: content, timestamp: Date())
        messages.append(message)
        print("User: \(content)")
    }

    func addNewAIMessage(content: String) {
        let message = Message(id: UUID(), role: "system", content: content, timestamp: Date())
        messages.append(message)
        print("AI: \(content)")
    }


}



