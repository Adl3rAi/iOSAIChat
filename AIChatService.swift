//
//  AIChatService.swift
//  AIChat
//
//  Created by 胡卿元 on 2023/7/22.
//

import Foundation
import Speech
import KeychainAccess

struct chatRequestData: Codable {
    let model: String
    var messages: [chatAPIMessage]
    let temperature: Double
    let max_tokens: Int
}

struct AIChatService {
    private let keychain = Keychain(service: "aiadler.AIChat")
    private var openAIAPIKey : String?
    let synthesizer = AVSpeechSynthesizer()
    let languages = ["English": "en-US", "中文": "zh-CN", "Deutsch": "de-DE"]
    
    init() {
        do {
            openAIAPIKey = try keychain.get("OpenAIAPIKey") ?? "nil"
            
        } catch let error {
            print("Error in the OpenAI API Key: \(error)")
        }
    }
    
    struct chatAPIResponse: Codable {
        struct Choice: Codable {
            struct Message: Codable {
                let content: String
            }

            let message: Message
        }

        let choices: [Choice]
    }
    
    func requestAIResponse(language: String, messages: [chatAPIMessage], completion: @escaping ((Result<String, Error>) -> Void)) {
//        let api = try! keychain.get("OpenAIAPIKey") ?? "nil"
//        print("The api in the keychain is now \(api)")
//        print("The real api is now \(openAIAPIKey)")
        let url = URL(string: "https://api.openai.com/v1/chat/completions")!
        var request = URLRequest(url: url)
        request.httpMethod = "Post"
        request.setValue("Bearer \(openAIAPIKey!)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        var requestData = chatRequestData(
            model: "gpt-3.5-turbo",
            messages: messages,
            temperature: 0.5,
            max_tokens: 1024
        )
        while calculateTokens(language: language, messages: requestData.messages) >= requestData.max_tokens {
            requestData.messages.removeFirst()
        }
        let encoder = JSONEncoder()
        request.httpBody = try! encoder.encode(requestData)

        let session = URLSession.shared

        let task = session.dataTask(with: request) { (data, response, error) in
            DispatchQueue.main.async {
                if let error = error {
                    completion(.failure(error))
                } else if let data = data {
                    do {
                        let apiResponse = try JSONDecoder().decode(chatAPIResponse.self, from: data)
                        let aiText = apiResponse.choices.first?.message.content
                        completion(.success(aiText ?? ""))
                    } catch {
                        print("Error: \(error)")
                        completion(.failure(error))
                    }
                }
            }
        }
        task.resume()
    }

    func calculateTokens(language: String, messages: [chatAPIMessage]) -> Int {
        var tokenCount = 0
        for message in messages {
            if language == "中文" {
                tokenCount += message.content.count
            } else {
                tokenCount += message.content.split(separator: " ").count
            }
        }
        return tokenCount
    }
    
    func textToSpeech(text: String, language: String) {
        let utterance = AVSpeechUtterance(string: text)
        utterance.rate = 0.57
        utterance.pitchMultiplier = 0.8
        utterance.postUtteranceDelay = 0.2
        utterance.volume = 0.8
        
        let voice = AVSpeechSynthesisVoice(language: languages[language])
        
        utterance.voice = voice
        
        synthesizer.speak(utterance)
    }
    
    func speechToText(audioFileURL: URL, completion: @escaping (String?) -> Void) {
        let url = URL(string: "https://api.openai.com/v1/audio/transcriptions")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(openAIAPIKey!)", forHTTPHeaderField: "Authorization")
        
        let boundary = UUID().uuidString
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        var data = Data()
        data.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
        data.append("Content-Disposition: form-data; name=\"file\"; filename=\"audio.mp3\"\r\n".data(using: .utf8)!)
        data.append("Content-Type: audio/mpeg\r\n\r\n".data(using: .utf8)!)
        do {
            let audioData = try Data(contentsOf: audioFileURL)
            data.append(audioData)
        } catch {
            print("Error: \(error)")
            completion(nil)
        }
        data.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)
        
        let task = URLSession.shared.uploadTask(with: request, from: data) { data, response, error in
            DispatchQueue.main.sync {
                guard let data = data, error == nil else {
                    print("Error: \(error?.localizedDescription ?? "Unknown error")")
                    completion(nil)
                    return
                }
                do {
                    let jsonObject = try JSONSerialization.jsonObject(with: data, options: [])
                    if let dictionary = jsonObject as? [String: Any],
                       let transcript = dictionary["transcript"] as? String {
                        completion(transcript)
                    } else {
                        print("Error: unable to parse transcript")
                        completion(nil)
                    }
                } catch {
                    print("Error: unable to parse JSON data - \(error)")
                    completion(nil)
                }
            }
        }
        task.resume()
    }

}









