//
//  ContentView.swift
//  chatterBot
//
//  Created by Justin Hold on 7/2/25.
//

import SwiftUI

struct ContentView: View {
    
    // MARK: - Properties
    /// API client instance for handling chat communication with the backend service.
    ///
    /// This client is initialized with the OpenAI API key and manages all requests
    /// to the chat completion endpoint. The client handles authentication, request
    /// formatting, and response parsing for the chat interface.
    ///
    /// - Note: The API key is embedded directly in the code. For production apps,
    ///   consider using secure storage methods like Keychain or environment variables.
    ///
    /// - Warning: This API key should be kept secure and not exposed in version control
    ///   or public repositories. Consider using configuration files or secure vaults.
//    @State private var client = APIClient(
//        apiKey: ""
//    )

    /// Array containing all messages in the current chat conversation.
    ///
    /// This array stores both user and AI messages in chronological order, maintaining
    /// the complete conversation history. Each message contains text content, sender
    /// identification, and unique identifiers for reference.
    ///
    /// The array is automatically updated when:
    /// - User sends a new message
    /// - AI generates a response
    /// - Messages are loaded from persistent storage (if implemented)
    ///
    /// - Note: Messages are appended in real-time and drive the SwiftUI interface updates.
    @State private var messages = [Message]()

    /// Current text input from the user in the message composition field.
    ///
    /// This property is bound to the text field where users type their messages.
    /// The text is automatically cleared after each message is sent to provide
    /// a clean input experience.
    ///
    /// - Note: Input validation occurs in `sendMessage()` where whitespace
    ///   and newlines are trimmed before processing.
    @State private var messageText: String = ""

    /// Boolean flag indicating whether the AI is currently generating a response.
    ///
    /// This property controls the display of typing indicators in the chat interface,
    /// providing visual feedback to users while waiting for AI responses.
    ///
    /// State transitions:
    /// - `false`: Default state, no typing indicator shown
    /// - `true`: AI is processing, typing indicator displayed
    ///
    /// - Note: This flag is automatically managed by the `sendMessage()` function
    ///   and should not be manually modified elsewhere in the interface.
    @State private var isTyping: Bool = false
    
    // MARK: - View Body
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                ScrollViewReader { proxy in
                    ScrollView {
                        LazyVStack(spacing: 8) {
                            ForEach(
                                messages,
                                content: MessageBubbleView.init
                            )
                            if isTyping {
                                HStack {
                                    TypingIndicator()
                                    Spacer()
                                }
                                .transition(.move(edge: .leading))
                            }
                        }
                        .padding(.horizontal)
                    }
                    .defaultScrollAnchor(.bottom)
                    .onChange(of: messages) {
                        Task {
                            try await Task.sleep(for: .seconds(0.2))
                            proxy.scrollTo(
                                messages.last?.id,
                                anchor: .bottom
                            )
                        }
                    }
                }
                
                MessageInputView(
                    messageText: $messageText,
                    onSend: sendMessage
                )
            }
        }
    }
    
    // MARK: - Logic
    /// Sends a user message and generates an AI response in the chat interface.
    ///
    /// This function handles the complete flow of sending a message:
    /// 1. Validates and processes the user input
    /// 2. Adds the user message to the conversation
    /// 3. Generates an AI response using the chat client
    /// 4. Displays typing indicators during response generation
    /// 5. Adds the AI response to the conversation with smooth animations
    ///
    /// The function includes built-in safety measures for minor-friendly conversations
    /// and handles errors gracefully to maintain a stable chat experience.
    ///
    /// - Note: This function performs asynchronous operations and includes artificial
    ///   delays to simulate realistic typing behavior.
    ///
    /// - Warning: Requires `client`, `messageText`, `messages`, and `isTyping` properties
    ///   to be properly initialized in the containing view or view model.
    ///
    /// - Important: The function will return early if the message text is empty or
    ///   contains only whitespace characters.
    func sendMessage() {
        
        // Trim whitespace and newlines from user input
        let prompt = messageText.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // Early return if message is empty after trimming
        guard prompt.isEmpty == false else { return }
        
        // Clear the input field immediately for better UX
        messageText = ""
        
        // Add user message to conversation with smooth animation
        withAnimation {
            messages.append(Message(text: prompt, isAI: false))
        }
        
        // Handle AI response generation asynchronously
        Task {
            
            do {
                // Find the most recent AI message for context continuity
                let lastAIMessage = messages.last(where: \.isAI)
                
                // Generate AI response with safety instructions
                // Uses async let for concurrent execution
                async let response = client.generateText(
                    from: prompt,
                    instructions: "You are ChatterBot, a bot designed for chatting only. You are addressing minors and easily offended people, so never use or tolerate offensive language.",
                    previousResponse: lastAIMessage?.id
                )
                
                // Brief delay before showing typing indicator
                try await Task.sleep(for: .seconds(1))
                isTyping = true
                
                // Create new AI message from response
                let newMessage = try await Message(
                    id: response.id,
                    text: response.message,
                    isAI: true
                )
                
                // Simulate realistic typing time
                try await Task.sleep(for: .seconds(2))
                isTyping = false
                
                // Add AI response to conversation with animation
                withAnimation {
                    messages.append(newMessage)
                }
                
            } catch {
                // Log error and ensure typing indicator is hidden
                print(error.localizedDescription)
                isTyping = false
            }
        }
    }
}

#Preview {
    ContentView()
}
