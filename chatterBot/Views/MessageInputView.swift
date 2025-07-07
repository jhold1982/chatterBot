//
//  MessageInputView.swift
//  chatterBot
//
//  Created by Justin Hold on 7/7/25.
//

import SwiftUI

struct MessageInputView: View {
    
    // MARK: - Properties
    @FocusState private var isInputFocused: Bool
    @Binding var messageText: String
    
    let onSend: () -> Void
    
    
    // MARK: - View Body
    var body: some View {
        
        HStack(spacing: 8) {
            TextField("Write something", text: $messageText, axis: .vertical)
                .focused($isInputFocused)
                .textFieldStyle(.roundedBorder)
                .onSubmit(sendMessage)
            
            Button(
                "Send Message",
                systemImage: "arrow.up.circle.fill",
                action: onSend
            )
            .labelStyle(.iconOnly)
            .font(.title)
            .disabled(
                messageText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
            )
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
        .onAppear {
            isInputFocused = true
        }
    }
    
    // MARK: - Logic
    func sendMessage() {
        onSend()
        isInputFocused = true
    }
}

#Preview {
    MessageInputView(messageText: .constant("Example")) { }
}
