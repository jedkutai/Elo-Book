//
//  MessageCell.swift
//  Elo Book
//
//  Created by Jed Kutai on 1/11/24.
//

import SwiftUI

struct MessageCell: View {
    @State var message: Message
    @State var messageUser: User
    @State var user: User
    
    private let messageWidth = UIScreen.main.bounds.height * 0.8
    
    var body: some View {
        // "standard" or "sharedPost" or "sharedProfile"
        switch message.messageType {
        case "standard":
            StandardMessageBubble(message: $message, messageUser: $messageUser, user: $user)
        case "sharedPost":
            SharedPostMessageBubble(message: $message, messageUser: $messageUser, user: $user)
        case "sharedProfile":
            SharedUserMessageBubble(message: $message, messageUser: $messageUser, user: $user)
        default:
            blank
        }
    }
    
    
    var blank: some View {
        NavigationStack {
            Text("Failed to load message")
        }
    }
    
}
