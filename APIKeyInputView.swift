//
//  APIKeyInputView.swift
//  AIChat
//
//

import SwiftUI

struct APIKeyInputView: View {
    @ObservedObject var apiKeyInputViewModel : APIKeyInputViewModel

    var body: some View {
        VStack{
            Spacer()
            Text("Please enter your OpenAI API key")
            HStack {
                Spacer()
                TextEditor(text: $apiKeyInputViewModel.userInput)
                    .frame(height: 100)
                    .font(.system(size: 20))
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.secondary, lineWidth: 1)
                    )
                Spacer()
            }
            Button(action: {
                apiKeyInputViewModel.submitAPIKey()
                
            }) {
                Text("Submit")
            }
            Spacer()
        }
    }
}

struct APIKeyInputView_Previews: PreviewProvider {
    static var previews: some View { let apiKeyInputViewModel = APIKeyInputViewModel()
        APIKeyInputView(apiKeyInputViewModel: apiKeyInputViewModel)
    }
}
