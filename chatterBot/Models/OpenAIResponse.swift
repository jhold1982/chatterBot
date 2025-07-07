//
//  OpenAIResponse.swift
//  chatterBot
//
//  Created by Justin Hold on 7/2/25.
//

import Foundation

struct OpenAIResponse: Decodable {
    
    let id: String
    let output: [OpenAIMessage]
}

struct OpenAIMessage: Decodable {
    
    let content: [OpenAIMessageContent]
}

struct OpenAIMessageContent: Decodable {
    
    let text: String
}
