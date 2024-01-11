//
//  UploadMessage.swift
//  Elo Book
//
//  Created by Jed Kutai on 1/10/24.
//

import Foundation
import PhotosUI
import SwiftUI
import Firebase
import UIKit

@MainActor
class UploadMessage: ObservableObject {

    @Published var messageImages: [Image] = []
    var uiImages: [UIImage] = []
    
    
    func loadImages(fromItem items: [PhotosPickerItem]) async {
        for item in items {
            
            guard let data = try? await item.loadTransferable(type: Data.self) else { return }
            guard let uiImage = (UIImage(data: data)) else { return }
            self.uiImages.append(uiImage)
            self.messageImages.append(Image(uiImage: uiImage))
        }
    }
    
    // either "standard" or "sharedPost" or "sharedProfile"
    func uploadMessage(user: User, recievingUsers: [User], caption: String) async throws {
        var filenames: [String] = []
        var imageUrls: [String] = []
        
        for uiImage in uiImages {
            let filename = NSUUID().uuidString
            guard let imageUrl = try await ImageUploader.uploadMessageImage(uid: user.id, image: uiImage, filename: filename) else { return }
            filenames.append(filename)
            imageUrls.append(imageUrl)
        }
        
        let recievingUsers3 = recievingUsers + [user]
        var recievingUsers2: [User] = []
        for user in recievingUsers3 {
            if !recievingUsers2.contains(where: { $0.id == user.id}) {
                recievingUsers2.append(user)
            }
        }
        
        let recievingUserIds = recievingUsers2.map { $0.id }.sorted()
        let query = Firestore.firestore().collection("threads")
            .whereField("userIds", isEqualTo: recievingUserIds)
        let querySnapshot = try await query.getDocuments()
        
        
        
        if let threadRef = querySnapshot.documents.first {
            // thread exists
            let threadDocId = threadRef.documentID
            
            let messageRef = Firestore.firestore().collection("threads").document(threadDocId).collection("messages").document()
            let messageDocId = messageRef.documentID
            let message = Message(id: messageDocId, threadId: threadDocId, userId: user.id, messageType: "standard", shareId: "", caption: caption, imageUrls: imageUrls, imageIds: filenames, messageSeenBy: [user.id])
            guard let encodedMessage = try? Firestore.Encoder().encode(message) else { return }
            try await messageRef.setData(encodedMessage)
            
            try await Firestore.firestore().collection("threads").document(threadDocId).updateData(["lastMessageTimeStamp": message.timestamp])
            try await Firestore.firestore().collection("threads").document(threadDocId).updateData(["lastMessageId": message.id])
        } else {
            // create new thread
            let threadRef = Firestore.firestore().collection("threads").document()
            let threadDocId = threadRef.documentID
            let thread = Thread(id: threadDocId, founderId: user.id, userIds: recievingUserIds)
            guard let encodedThread = try? Firestore.Encoder().encode(thread) else { return }
            try await threadRef.setData(encodedThread)
            
            let messageRef = Firestore.firestore().collection("threads").document(threadDocId).collection("messages").document()
            let messageDocId = messageRef.documentID
            let message = Message(id: messageDocId, threadId: threadDocId, userId: user.id, messageType: "standard", shareId: "", caption: caption, imageUrls: imageUrls, imageIds: filenames, messageSeenBy: [user.id])
            guard let encodedMessage = try? Firestore.Encoder().encode(message) else { return }
            try await messageRef.setData(encodedMessage)
            
            try await threadRef.updateData(["lastMessageTimeStamp": message.timestamp])
            try await threadRef.updateData(["lastMessageId": message.id])
        }
        
        
    }
    
    // either "standard" or "sharedPost" or "sharedProfile"
    func uploadSharedPost(user: User, post: Post, recievingUsers: [User], caption: String) async throws {
        let recievingUsers3 = recievingUsers + [user]
        var recievingUsers2: [User] = []
        for user in recievingUsers3 {
            if !recievingUsers2.contains(where: { $0.id == user.id}) {
                recievingUsers2.append(user)
            }
        }
        
        let recievingUserIds = recievingUsers2.map { $0.id }.sorted()
        let query = Firestore.firestore().collection("threads")
            .whereField("userIds", isEqualTo: recievingUserIds)
        let querySnapshot = try await query.getDocuments()
        
        
        
        if let threadRef = querySnapshot.documents.first {
            let threadDocId = threadRef.documentID
            
            let messageRef = Firestore.firestore().collection("threads").document(threadDocId).collection("messages").document()
            let messageDocId = messageRef.documentID
            let message = Message(id: messageDocId, threadId: threadDocId, userId: user.id, messageType: "sharedPost", shareId: post.id, caption: caption, imageUrls: [], imageIds: [], messageSeenBy: [user.id])
            guard let encodedMessage = try? Firestore.Encoder().encode(message) else { return }
            try await messageRef.setData(encodedMessage)
            
            try await Firestore.firestore().collection("threads").document(threadDocId).updateData(["lastMessageTimeStamp": message.timestamp])
            try await Firestore.firestore().collection("threads").document(threadDocId).updateData(["lastMessageId": message.id])
        } else {
            
            let threadRef = Firestore.firestore().collection("threads").document()
            let threadDocId = threadRef.documentID
            let thread = Thread(id: threadDocId, founderId: user.id, userIds: recievingUserIds)
            guard let encodedThread = try? Firestore.Encoder().encode(thread) else { return }
            try await threadRef.setData(encodedThread)
            
            let messageRef = Firestore.firestore().collection("threads").document(threadDocId).collection("messages").document()
            let messageDocId = messageRef.documentID
            let message = Message(id: messageDocId, threadId: threadDocId, userId: user.id, messageType: "sharedPost", shareId: post.id, caption: caption, imageUrls: [], imageIds: [], messageSeenBy: [user.id])
            guard let encodedMessage = try? Firestore.Encoder().encode(message) else { return }
            try await messageRef.setData(encodedMessage)
            
            try await threadRef.updateData(["lastMessageTimeStamp": message.timestamp])
            try await threadRef.updateData(["lastMessageId": message.id])
        }
        
        
    }

    // either "standard" or "sharedPost" or "sharedProfile"
    func uploadSharedProfile(user: User, sharedUser: User, recievingUsers: [User], caption: String) async throws {
        let recievingUsers3 = recievingUsers + [user]
        var recievingUsers2: [User] = []
        for user in recievingUsers3 {
            if !recievingUsers2.contains(where: { $0.id == user.id}) {
                recievingUsers2.append(user)
            }
        }
        
        let recievingUserIds = recievingUsers2.map { $0.id }.sorted()
        let query = Firestore.firestore().collection("threads")
            .whereField("userIds", isEqualTo: recievingUserIds)
        let querySnapshot = try await query.getDocuments()
        
        
        
        if let threadRef = querySnapshot.documents.first {
            let threadDocId = threadRef.documentID
            
            let messageRef = Firestore.firestore().collection("threads").document(threadDocId).collection("messages").document()
            let messageDocId = messageRef.documentID
            let message = Message(id: messageDocId, threadId: threadDocId, userId: user.id, messageType: "sharedProfile", shareId: sharedUser.id, caption: caption, imageUrls: [], imageIds: [], messageSeenBy: [user.id])
            guard let encodedMessage = try? Firestore.Encoder().encode(message) else { return }
            try await messageRef.setData(encodedMessage)
            
            try await Firestore.firestore().collection("threads").document(threadDocId).updateData(["lastMessageTimeStamp": message.timestamp])
            try await Firestore.firestore().collection("threads").document(threadDocId).updateData(["lastMessageId": message.id])
        } else {
            
            let threadRef = Firestore.firestore().collection("threads").document()
            let threadDocId = threadRef.documentID
            let thread = Thread(id: threadDocId, founderId: user.id, userIds: recievingUserIds)
            guard let encodedThread = try? Firestore.Encoder().encode(thread) else { return }
            try await threadRef.setData(encodedThread)
            
            let messageRef = Firestore.firestore().collection("threads").document(threadDocId).collection("messages").document()
            let messageDocId = messageRef.documentID
            let message = Message(id: messageDocId, threadId: threadDocId, userId: user.id, messageType: "sharedProfile", shareId: sharedUser.id, caption: caption, imageUrls: [], imageIds: [], messageSeenBy: [user.id])
            guard let encodedMessage = try? Firestore.Encoder().encode(message) else { return }
            try await messageRef.setData(encodedMessage)
            
            try await threadRef.updateData(["lastMessageTimeStamp": message.timestamp])
            try await threadRef.updateData(["lastMessageId": message.id])
        }
        
        
    }
}
