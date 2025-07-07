//
//  Message.swift
//  chatterBot
//
//  Created by Justin Hold on 7/3/25.
//

import Foundation

struct Message: Equatable, Identifiable {
    
    var id = UUID().uuidString
    var text: String
    var isAI: Bool
    var timestamp = Date.now
    
    static let messageExample = "Example"
}
