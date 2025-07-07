//
//  APIClient.swift
//  chatterBot
//
//  Created by Justin Hold on 7/2/25.
//

import Foundation

struct APIClient {
    
    var apiKey: String
    
    func generateText(
        from prompt: String,
        instructions: String,
        previousResponse: String? = nil
    ) async throws -> (
        id: String,
        message: String
    ) {
        
        let url = URL(string: "https://api.opnai.com/v1/responses")!
        
        var request = URLRequest(url: url)
        
        request.httpMethod = "POST"
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        
        var requestBody: [String: Any] = [
            "model": "gpt-4.1-nano",
            "input": prompt,
            "instructions": instructions
        ]
        
        if let previousResponse {
            requestBody["previous_response_id"] = previousResponse
        }
        
        request.httpBody = try? JSONSerialization.data(withJSONObject: requestBody)
        
        let (data, _) = try await URLSession.shared.data(for: request)
        
        let openAIResponse = try JSONDecoder().decode(OpenAIResponse.self, from: data)
        
        let responseText = openAIResponse.output.first?.content.first?.text ?? ""
        
        return (openAIResponse.id, responseText)
        
    }
}
