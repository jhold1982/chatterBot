//
//  MessageBubbleView.swift
//  chatterBot
//
//  Created by Justin Hold on 7/3/25.
//

import SwiftUI

struct MessageBubbleView: View {
    
    // MARK: - Properties
    let message: Message
    
    
    // MARK: - View Body
    var body: some View {
        let alignment = message.isAI ? Alignment.leading : .trailing
        
        Text(message.text)
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .foregroundStyle(message.isAI ? Color.primary : .white)
            .background(message.isAI ? .gray.opacity(0.2) : .blue)
            .clipShape(.rect(cornerRadius: 16))
            .containerRelativeFrame(.horizontal, alignment: alignment) { size, axis in
                size * 0.75
                
            }
            .frame(maxWidth: .infinity, alignment: alignment)
            .transition(.move(edge: message.isAI ? .leading : .trailing))
            .id(message.id)
    }
}

#Preview {
    MessageBubbleView(
        message: Message(
            text: "Hello, world",
            isAI: true
        )
    )
}
