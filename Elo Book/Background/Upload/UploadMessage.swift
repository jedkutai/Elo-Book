//
//  UploadMessage.swift
//  Elo Book
//
//  Created by Jed Kutai on 1/12/24.
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
    
    func uploadMessageCaptionViaEvent(user: User, event: Event, caption: String) async throws {
        let eventDocId = event.id
        
        let messageRef = Firestore.firestore()
            .collection("events")
            .document(eventDocId)
            .collection("messages").document()
        
        let messageDocId = messageRef.documentID
        
        let messageToUpload = Message2(id: messageDocId, threadId: eventDocId, userId: user.id, caption: caption) // create the message
        guard let encodedMessage = try? Firestore.Encoder().encode(messageToUpload) else { return } // encode message
        try await messageRef.setData(encodedMessage) // upload the message
    }
    
    func uploadMessageCaptionViaThread(user: User, thread: Thread, caption: String) async throws {
        let threadDocId = thread.id
        
        let messageRef = Firestore.firestore()
            .collection("threads")
            .document(threadDocId)
            .collection("messages").document()
        
        let messageDocId = messageRef.documentID
        
        let messageToUpload = Message2(id: messageDocId, threadId: threadDocId, userId: user.id, caption: caption, messageSeenBy: [user.id]) // create the message
        guard let encodedMessage = try? Firestore.Encoder().encode(messageToUpload) else { return } // encode message
        try await messageRef.setData(encodedMessage) // upload the message
        try await Firestore.firestore().collection("threads").document(threadDocId).updateData(["lastMessageTimeStamp": messageToUpload.timestamp]) // update the last message field for the thread
    }
    
    func uploadMessageCaption(user: User, receivingUsers: [User], caption: String) async throws {
        let allThreadUsers: [User] = receivingUsers + [user] // add sender and receiving users
        
        var threadUsersNoDuplicates: [User] = [] // make sure each user is only in here once
        for oneUser in allThreadUsers {
            if !threadUsersNoDuplicates.contains(where: { $0.id == oneUser.id}) {
                threadUsersNoDuplicates.append(oneUser)
            }
        }
        
        let threadUserIdsSorted = threadUsersNoDuplicates.map { $0.id }.sorted() // put all ids in array and sort them

        // check to see if a thread already exists with these exact users
        let query = Firestore.firestore().collection("threads")
            .whereField("memberIds", isEqualTo: threadUserIdsSorted)
        
        let querySnapshot = try await query.getDocuments()
        
        if let threadRef = querySnapshot.documents.first {
            // thread exists so upload message
            
            let threadDocId = threadRef.documentID
            
            let messageRef = Firestore.firestore()
                .collection("threads")
                .document(threadDocId)
                .collection("messages").document()
            
            let messageDocId = messageRef.documentID
            
            let messageToUpload = Message2(id: messageDocId, threadId: threadDocId, userId: user.id, caption: caption, messageSeenBy: [user.id]) // create the message
            guard let encodedMessage = try? Firestore.Encoder().encode(messageToUpload) else { return } // encode message
            try await messageRef.setData(encodedMessage) // upload the message
            try await Firestore.firestore().collection("threads").document(threadDocId).updateData(["lastMessageTimeStamp": messageToUpload.timestamp]) // update the last message field for the thread
            
        } else {
            // thread doesnt exist so create thread then upload message
            let threadRef = Firestore.firestore().collection("threads").document()
            let threadDocId = threadRef.documentID
            let thread = Thread(id: threadDocId, ownerId: user.id, memberIds: threadUserIdsSorted)
            guard let encodedThread = try? Firestore.Encoder().encode(thread) else { return }
            try await threadRef.setData(encodedThread)
        
            // pasted code from second half if if statement
            let messageRef = Firestore.firestore()
                .collection("threads")
                .document(threadDocId)
                .collection("messages").document()
            
            let messageDocId = messageRef.documentID
            
            let messageToUpload = Message2(id: messageDocId, threadId: threadDocId, userId: user.id, caption: caption, messageSeenBy: [user.id]) // create the message
            guard let encodedMessage = try? Firestore.Encoder().encode(messageToUpload) else { return } // encode message
            try await messageRef.setData(encodedMessage) // upload the message
            try await Firestore.firestore().collection("threads").document(threadDocId).updateData(["lastMessageTimeStamp": messageToUpload.timestamp]) // update the last message field for the thread
            
        }
    }
    
    func uploadMessageImagesViaThread(user: User, thread: Thread) async throws {
        if !uiImages.isEmpty {
            var filenames: [String] = [] // for deleting images late
            var imageUrls: [String] = [] // for showing image
            
            for uiImage in uiImages {
                let filename = NSUUID().uuidString
                guard let imageUrl = try await ImageUploader.uploadMessageImage(uid: user.id, image: uiImage, filename: filename) else { return }
                filenames.append(filename)
                imageUrls.append(imageUrl)
            }
            
            let threadDocId = thread.id
            
            let messageRef = Firestore.firestore()
                .collection("threads")
                .document(threadDocId)
                .collection("messages").document()
            
            let messageDocId = messageRef.documentID
            
            let messageToUpload = Message2(id: messageDocId, threadId: threadDocId, userId: user.id, imageUrls: imageUrls, imageIds: filenames, messageSeenBy: [user.id]) // create the message
            guard let encodedMessage = try? Firestore.Encoder().encode(messageToUpload) else { return } // encode message
            try await messageRef.setData(encodedMessage) // upload the message
            try await Firestore.firestore().collection("threads").document(threadDocId).updateData(["lastMessageTimeStamp": messageToUpload.timestamp]) // update the last message field for the thread
        }
    }
    
    func uploadMessageImages(user: User, receivingUsers: [User]) async throws {
        if !uiImages.isEmpty {
            var filenames: [String] = [] // for deleting images late
            var imageUrls: [String] = [] // for showing image
            
            for uiImage in uiImages {
                let filename = NSUUID().uuidString
                guard let imageUrl = try await ImageUploader.uploadMessageImage(uid: user.id, image: uiImage, filename: filename) else { return }
                filenames.append(filename)
                imageUrls.append(imageUrl)
            }
            
            let allThreadUsers: [User] = receivingUsers + [user] // add sender and receiving users
            
            var threadUsersNoDuplicates: [User] = [] // make sure each user is only in here once
            for oneUser in allThreadUsers {
                if !threadUsersNoDuplicates.contains(where: { $0.id == oneUser.id}) {
                    threadUsersNoDuplicates.append(oneUser)
                }
            }
            
            let threadUserIdsSorted = threadUsersNoDuplicates.map { $0.id }.sorted() // put all ids in array and sort them

            // check to see if a thread already exists with these exact users
            let query = Firestore.firestore().collection("threads")
                .whereField("memberIds", isEqualTo: threadUserIdsSorted)
            
            let querySnapshot = try await query.getDocuments()
            
            if let threadRef = querySnapshot.documents.first {
                // thread exists so upload message
                
                let threadDocId = threadRef.documentID
                
                let messageRef = Firestore.firestore()
                    .collection("threads")
                    .document(threadDocId)
                    .collection("messages").document()
                
                let messageDocId = messageRef.documentID
                
                let messageToUpload = Message2(id: messageDocId, threadId: threadDocId, userId: user.id, imageUrls: imageUrls, imageIds: filenames, messageSeenBy: [user.id]) // create the message
                guard let encodedMessage = try? Firestore.Encoder().encode(messageToUpload) else { return } // encode message
                try await messageRef.setData(encodedMessage) // upload the message
                try await Firestore.firestore().collection("threads").document(threadDocId).updateData(["lastMessageTimeStamp": messageToUpload.timestamp]) // update the last message field for the thread
                
            } else {
                // thread doesnt exist so create thread then upload message
                let threadRef = Firestore.firestore().collection("threads").document()
                let threadDocId = threadRef.documentID
                let thread = Thread(id: threadDocId, ownerId: user.id, memberIds: threadUserIdsSorted)
                guard let encodedThread = try? Firestore.Encoder().encode(thread) else { return }
                try await threadRef.setData(encodedThread)
            
                // pasted code from second half if if statement
                let messageRef = Firestore.firestore()
                    .collection("threads")
                    .document(threadDocId)
                    .collection("messages").document()
                
                let messageDocId = messageRef.documentID
                
                let messageToUpload = Message2(id: messageDocId, threadId: threadDocId, userId: user.id, imageUrls: imageUrls, imageIds: filenames, messageSeenBy: [user.id]) // create the message
                guard let encodedMessage = try? Firestore.Encoder().encode(messageToUpload) else { return } // encode message
                try await messageRef.setData(encodedMessage) // upload the message
                try await Firestore.firestore().collection("threads").document(threadDocId).updateData(["lastMessageTimeStamp": messageToUpload.timestamp]) // update the last message field for the thread
                
            }
        }
    }
    
    func uploadMessageSharedProfileViaThread(user: User, thread: Thread, sharedUser: User) async throws {
        let threadDocId = thread.id
        
        let messageRef = Firestore.firestore()
            .collection("threads")
            .document(threadDocId)
            .collection("messages").document()
        
        let messageDocId = messageRef.documentID
        
        let messageToUpload = Message2(id: messageDocId, threadId: threadDocId, userId: user.id, sharedUserId: sharedUser.id, messageSeenBy: [user.id]) // create the message
        guard let encodedMessage = try? Firestore.Encoder().encode(messageToUpload) else { return } // encode message
        try await messageRef.setData(encodedMessage) // upload the message
        try await Firestore.firestore().collection("threads").document(threadDocId).updateData(["lastMessageTimeStamp": messageToUpload.timestamp]) // update the last message field for the thread
    }
    
    func uploadMessageSharedProfile(user: User, receivingUsers: [User], sharedUser: User) async throws {
        let allThreadUsers: [User] = receivingUsers + [user] // add sender and receiving users
        
        var threadUsersNoDuplicates: [User] = [] // make sure each user is only in here once
        for oneUser in allThreadUsers {
            if !threadUsersNoDuplicates.contains(where: { $0.id == oneUser.id}) {
                threadUsersNoDuplicates.append(oneUser)
            }
        }
        
        let threadUserIdsSorted = threadUsersNoDuplicates.map { $0.id }.sorted() // put all ids in array and sort them

        // check to see if a thread already exists with these exact users
        let query = Firestore.firestore().collection("threads")
            .whereField("memberIds", isEqualTo: threadUserIdsSorted)
        
        let querySnapshot = try await query.getDocuments()
        
        if let threadRef = querySnapshot.documents.first {
            // thread exists so upload message
            
            let threadDocId = threadRef.documentID
            
            let messageRef = Firestore.firestore()
                .collection("threads")
                .document(threadDocId)
                .collection("messages").document()
            
            let messageDocId = messageRef.documentID
            
            let messageToUpload = Message2(id: messageDocId, threadId: threadDocId, userId: user.id, sharedUserId: sharedUser.id, messageSeenBy: [user.id]) // create the message
            guard let encodedMessage = try? Firestore.Encoder().encode(messageToUpload) else { return } // encode message
            try await messageRef.setData(encodedMessage) // upload the message
            try await Firestore.firestore().collection("threads").document(threadDocId).updateData(["lastMessageTimeStamp": messageToUpload.timestamp]) // update the last message field for the thread
            
        } else {
            // thread doesnt exist so create thread then upload message
            let threadRef = Firestore.firestore().collection("threads").document()
            let threadDocId = threadRef.documentID
            let thread = Thread(id: threadDocId, ownerId: user.id, memberIds: threadUserIdsSorted)
            guard let encodedThread = try? Firestore.Encoder().encode(thread) else { return }
            try await threadRef.setData(encodedThread)
        
            // pasted code from second half if if statement
            let messageRef = Firestore.firestore()
                .collection("threads")
                .document(threadDocId)
                .collection("messages").document()
            
            let messageDocId = messageRef.documentID
            
            let messageToUpload = Message2(id: messageDocId, threadId: threadDocId, userId: user.id, sharedUserId: sharedUser.id, messageSeenBy: [user.id]) // create the message
            guard let encodedMessage = try? Firestore.Encoder().encode(messageToUpload) else { return } // encode message
            try await messageRef.setData(encodedMessage) // upload the message
            try await Firestore.firestore().collection("threads").document(threadDocId).updateData(["lastMessageTimeStamp": messageToUpload.timestamp]) // update the last message field for the thread
            
        }
    }
    
    func uploadMessageSharedPostViaThread(user: User, thread: Thread, sharedPost: Post) async throws {
        let threadDocId = thread.id
        
        let messageRef = Firestore.firestore()
            .collection("threads")
            .document(threadDocId)
            .collection("messages").document()
        
        let messageDocId = messageRef.documentID
        
        let messageToUpload = Message2(id: messageDocId, threadId: threadDocId, userId: user.id, sharedPostId: sharedPost.id, messageSeenBy: [user.id]) // create the message
        guard let encodedMessage = try? Firestore.Encoder().encode(messageToUpload) else { return } // encode message
        try await messageRef.setData(encodedMessage) // upload the message
        try await Firestore.firestore().collection("threads").document(threadDocId).updateData(["lastMessageTimeStamp": messageToUpload.timestamp]) // update the last message field for the thread
    }
    
    func uploadMessageSharedPost(user: User, receivingUsers: [User], sharedPost: Post) async throws {
        let allThreadUsers: [User] = receivingUsers + [user] // add sender and receiving users
        
        var threadUsersNoDuplicates: [User] = [] // make sure each user is only in here once
        for oneUser in allThreadUsers {
            if !threadUsersNoDuplicates.contains(where: { $0.id == oneUser.id}) {
                threadUsersNoDuplicates.append(oneUser)
            }
        }
        
        let threadUserIdsSorted = threadUsersNoDuplicates.map { $0.id }.sorted() // put all ids in array and sort them

        // check to see if a thread already exists with these exact users
        let query = Firestore.firestore().collection("threads")
            .whereField("memberIds", isEqualTo: threadUserIdsSorted)
        
        let querySnapshot = try await query.getDocuments()
        
        if let threadRef = querySnapshot.documents.first {
            // thread exists so upload message
            
            let threadDocId = threadRef.documentID
            
            let messageRef = Firestore.firestore()
                .collection("threads")
                .document(threadDocId)
                .collection("messages").document()
            
            let messageDocId = messageRef.documentID
            
            let messageToUpload = Message2(id: messageDocId, threadId: threadDocId, userId: user.id, sharedPostId: sharedPost.id, messageSeenBy: [user.id]) // create the message
            guard let encodedMessage = try? Firestore.Encoder().encode(messageToUpload) else { return } // encode message
            try await messageRef.setData(encodedMessage) // upload the message
            try await Firestore.firestore().collection("threads").document(threadDocId).updateData(["lastMessageTimeStamp": messageToUpload.timestamp]) // update the last message field for the thread
            
        } else {
            // thread doesnt exist so create thread then upload message
            let threadRef = Firestore.firestore().collection("threads").document()
            let threadDocId = threadRef.documentID
            let thread = Thread(id: threadDocId, ownerId: user.id, memberIds: threadUserIdsSorted)
            guard let encodedThread = try? Firestore.Encoder().encode(thread) else { return }
            try await threadRef.setData(encodedThread)
        
            // pasted code from second half if if statement
            let messageRef = Firestore.firestore()
                .collection("threads")
                .document(threadDocId)
                .collection("messages").document()
            
            let messageDocId = messageRef.documentID
            
            let messageToUpload = Message2(id: messageDocId, threadId: threadDocId, userId: user.id, sharedPostId: sharedPost.id, messageSeenBy: [user.id]) // create the message
            guard let encodedMessage = try? Firestore.Encoder().encode(messageToUpload) else { return } // encode message
            try await messageRef.setData(encodedMessage) // upload the message
            try await Firestore.firestore().collection("threads").document(threadDocId).updateData(["lastMessageTimeStamp": messageToUpload.timestamp]) // update the last message field for the thread
            
        }
    }
}
