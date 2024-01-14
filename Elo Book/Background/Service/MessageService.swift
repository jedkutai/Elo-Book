//
//  MessageManager.swift
//  Elo Book
//
//  Created by Jed Kutai on 1/13/24.
//

import Foundation
import Firebase

struct MessageService {
    
    static func messageSeenByUser(user: User, message: Message2) async throws {
        let docRef = Firestore.firestore().collection("threads").document(message.threadId).collection("messages").document(message.id)
        let snapshot = try await docRef.getDocument()
        var freshMessage = try snapshot.data(as: Message2.self)
        if let seenBy = freshMessage.messageSeenBy {
            if !seenBy.contains(user.id) {
                freshMessage.messageSeenBy = seenBy + [user.id]
                let updatedData = try Firestore.Encoder().encode(freshMessage)
                try await docRef.setData(updatedData, merge: true)
            }
        }
    }
}
