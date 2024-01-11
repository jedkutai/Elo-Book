//
//  MessageService.swift
//  Elo Book
//
//  Created by Jed Kutai on 1/10/24.
//

import Foundation
import Firebase

struct MessageService {
    
    static func leaveGroupChat(user: User, thread: Thread) async throws {
        let threadRef = Firestore.firestore().collection("threads").document(thread.id)
        let groupChat = try await threadRef.getDocument(as: Thread.self)
        
        var userIds = groupChat.userIds
        if let indexToRemove = userIds.firstIndex(of: user.id) {
            userIds.remove(at: indexToRemove)
        }
        
        try await threadRef.updateData(["userIds": userIds])
        
    }
    
    static func addUsersToGroupChat(usersToAdd: [User], thread: Thread) async throws {
        let threadRef = Firestore.firestore().collection("threads").document(thread.id)
        let groupChat = try await threadRef.getDocument(as: Thread.self)
        
        var userIds = groupChat.userIds
        let newUserIds = usersToAdd.map { $0.id }
        
        for userId in newUserIds {
            if !userIds.contains(userId) {
                userIds.append(userId)
            }
        }
        
        userIds.sort()
        try await threadRef.updateData(["userIds": userIds])
    }
}
