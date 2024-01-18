//
//  MessageManager.swift
//  Elo Book
//
//  Created by Jed Kutai on 1/13/24.
//

import Foundation
import Firebase

struct MessageService {
    // g7doW5kVHEWC5aXQu8SAmQ5qln22
    static func leaveGroupChat(user: User, thread: Thread) async throws {
        let threadRef = Firestore.firestore().collection("threads").document(thread.id)
        let thread = try await threadRef.getDocument(as: Thread.self)
        
        if let memberIds = thread.memberIds {
            let userIdToFilter = user.id
            
            var updatedMemberIds = memberIds.filter { memberId in
                return memberId != userIdToFilter
            }
            
            updatedMemberIds.sort()
            try await threadRef.updateData(["memberIds": updatedMemberIds])
        }

    }
    
    static func addUsersToGroupChat(usersToAdd: [User], thread: Thread) async throws {
        let threadRef = Firestore.firestore().collection("threads").document(thread.id)
        let thread = try await threadRef.getDocument(as: Thread.self)
        
        if let memberIds = thread.memberIds {
            var updatedMemberIds = memberIds
            
            let newMemberIds = usersToAdd.map { $0.id }
            
            for userId in newMemberIds {
                if !updatedMemberIds.contains(userId) {
                    updatedMemberIds.append(userId)
                }
            }
            
            updatedMemberIds.sort()
            try await threadRef.updateData(["memberIds": updatedMemberIds])
        }
        
        
    }
    
    
    static func unreadMessagesCount(user: User, threads: [Thread]) async throws -> Int {
        var unreadMessages = 0
        
        for thread in threads {
            let lastMessage = try await FetchService.fetchLastMessageByThread(thread: thread)
            
            if let messageSeenBy = lastMessage.messageSeenBy {
                if !messageSeenBy.contains(user.id) {
                    unreadMessages += 1
                }
            }
        }
        
        return unreadMessages
    }
    
    
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
