//
//  AIChatView.swift
//  AIChat
//
//  Created by 胡卿元 on 2023/7/22.
//

import SwiftUI

struct AIChatView: View {
    @ObservedObject var aiChatViewModel: AIChatViewModel

    @State private var textInput: String = ""

    var body: some View {
        VStack {
            LanguagePicker()
            ScrollViewReader { reader in
                ScrollView {
                    VStack(alignment: .leading, spacing: 10) {
                        ForEach(aiChatViewModel.messages) {
                            message in
                            messageBubbleView(viewModel: aiChatViewModel, role: message.role, content: message.content
                            )
                        }
                    }
                    .padding()
                    .onChange(of: aiChatViewModel.messages) { _ in
                        withAnimation {
                           if let lastMessage = aiChatViewModel.messages.last {
                               if lastMessage.role == "user" {
                                   reader.scrollTo(lastMessage.id, anchor: .bottom)
                               }
                               else {
                                   let secondLastMessage = aiChatViewModel.messages[aiChatViewModel.messages.count - 2]
                                   reader.scrollTo(secondLastMessage.id, anchor: .top)
                               }
                           }
                       }
                    }
                }
            }
            HStack {
                TextEditor(text: $textInput)
                    .frame(height: 100)
                    .font(.system(size: 20))
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.secondary, lineWidth: 1)
                    )
                Button(action: {
                    if(textInput != "") {
                        aiChatViewModel.handleTextInput(text: textInput)
                        textInput = ""
                    }
                }) {
                    if aiChatViewModel.userLanguage == "English" {
                        Text("Send")
                    } else if aiChatViewModel.userLanguage == "中文" {
                        Text("发送")
                    } else if aiChatViewModel.userLanguage == "Deutsch" {
                        Text("Senden")
                    }
                }
            }
            .padding()
        }
    }
}

struct messageBubbleView: View {
    var viewModel: AIChatViewModel
    var role: String
    var content: String
    var body: some View {
        if role == "user" {
            HStack {
                Spacer()
                Text(content)
                    .font(.system(size: 20))
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
        } else if role == "system" {
            VStack {
                HStack {
                    Button(action: {
                        self.viewModel.playAudio(text: content, language: UserDefaults.standard.string(forKey: "language") ?? "English")
                    }) {
                        Image(systemName: "play.circle")
                    }
                    Spacer()
                }
                HStack {
                    Text(content)
                        .font(.system(size: 20))
                        .padding()
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        Spacer()
                }
            }
        }
    }
}

struct LanguagePicker: View {
    let languages = ["English", "中文", "Deutsch"]
    @State private var selectedLanguage = UserDefaults.standard.string(forKey: "language") ?? "English"

    var body: some View {
        Picker("Language", selection: $selectedLanguage) {
            ForEach(languages, id: \.self) {
                Text($0)
            }
        }
        .pickerStyle(MenuPickerStyle())
        .onChange(of: selectedLanguage) { newValue in
            UserDefaults.standard.set(newValue, forKey: "language")
        }
    }
}

struct AIChatView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = AIChatViewModel()
        AIChatView(aiChatViewModel: viewModel)
    }
}
