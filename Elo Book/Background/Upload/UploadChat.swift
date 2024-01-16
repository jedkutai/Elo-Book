//
//  UploadChat.swift
//  Elo Book
//
//  Created by Jed Kutai on 1/15/24.
//

import Foundation
import PhotosUI
import SwiftUI
import Firebase
import UIKit

@MainActor
class UploadChat: ObservableObject {
    
    static func uploadChat(user: User, event: Event, caption: String) async throws {
        let eventDocId = event.id
        
        let chatRef = Firestore.firestore()
            .collection("events")
            .document(eventDocId)
            .collection("chats").document()
        
        let chatDocId = chatRef.documentID
        
        var chatToUpload: Chat?
        
        if let username = user.username, let displayedBadge = user.displayedBadge {
            chatToUpload = Chat(id: chatDocId, eventId: event.id, userId: user.id, username: username, displayedBadge: displayedBadge, caption: caption)
        } else if let username = user.username {
            chatToUpload = Chat(id: chatDocId, eventId: event.id, userId: user.id, username: username, caption: caption)
        }
        
        if let chatToUpload = chatToUpload {
            guard let encodedChat = try? Firestore.Encoder().encode(chatToUpload) else { return }
            try await chatRef.setData(encodedChat)
        }
    }
}


