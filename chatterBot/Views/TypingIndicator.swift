//
//  TypingIndicator.swift
//  chatterBot
//
//  Created by Justin Hold on 7/7/25.
//

import SwiftUI

struct TypingIndicator: View {
    
    // MARK: - Properties
    @State private var animatingDots: Bool = false
    
    
    // MARK: - View Body
    var body: some View {
        Image(systemName: "ellipsis")
            .symbolEffect(.variableColor, isActive: animatingDots)
            .font(.title)
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(.gray.opacity(0.2))
            .clipShape(.rect(cornerRadius: 16))
            .onAppear {
                withAnimation(.linear.repeatForever()) {
                    animatingDots = true
                }
            }
    }
}

#Preview {
    TypingIndicator()
}
