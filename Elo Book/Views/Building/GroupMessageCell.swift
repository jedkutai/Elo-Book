//
//  GroupMessageCell.swift
//  Elo Book
//
//  Created by Jed Kutai on 1/11/24.
//

import SwiftUI

struct GroupMessageCell: View {
    @State var message: Message
    @State var messageUser: User
    @State var user: User
    @State var messageSetting: GroupMessageSettings
    
    private let messageWidth = UIScreen.main.bounds.height * 0.8
    
    var body: some View {
        // "standard" or "sharedPost" or "sharedProfile"
        switch message.messageType {
        case "standard":
            StandardGroupMessageBubble(message: $message, messageUser: $messageUser, user: $user, messageSetting: $messageSetting)
        case "sharedPost":
            SharedPostGroupMessageBubble(message: $message, messageUser: $messageUser, user: $user, messageSetting: $messageSetting)
        case "sharedProfile":
            SharedUserGroupMessageBubble(message: $message, messageUser: $messageUser, user: $user, messageSetting: $messageSetting)
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
