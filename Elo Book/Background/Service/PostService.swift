//
//  PostService.swift
//  Elo
//
//  Created by Jed Kutai on 12/16/23.
//

import Foundation
import Firebase
import FirebaseStorage
import FirebaseFirestore

struct PostService {
    static func deletePost(post: Post) async throws {
        
        // delete post from posts, user and events
        let postRef = Firestore.firestore().collection("posts").document(post.id)
        try await postRef.delete()
        
        //delete likes
        let query = Firestore.firestore().collection("posts").document(post.id).collection("likes")
        let snapshot = try await query.getDocuments()
        for document in snapshot.documents {
            let docRef = Firestore.firestore().collection("likes").document(document.documentID)
            try await docRef.delete()
        }
        
    }
    
    
    static func likePost(post: Post, user: User) async throws {
        let postId = post.id
        let postUserId = post.userId
        let userId = user.id
        
        if postUserId != userId {
            let likeRef1 = Firestore.firestore().collection("posts").document(postId).collection("likes")
            let query = likeRef1
                .whereField("userId", isEqualTo: userId)
            
            let querySnapshot = try await query.getDocuments()
            
            
            if querySnapshot.documents.first != nil {
                
            } else {
                let likeRef = Firestore.firestore().collection("posts").document(postId).collection("likes").document()
                let docId = likeRef.documentID
                
                let like = PostLike(id: docId, postId: postId, userId: userId)
                guard let encodedLike = try? Firestore.Encoder().encode(like) else { return }
                try await likeRef.setData(encodedLike)
                
                let docRef = Firestore.firestore().collection("posts").document(postId)
                let document = try await docRef.getDocument()
                var post = try document.data(as: Post.self)
                post.score += 1
                let updatedData = try Firestore.Encoder().encode(post)
                try await docRef.setData(updatedData, merge: true)
                
                let userRef = Firestore.firestore().collection("users").document(postUserId)
                let userDoc = try await userRef.getDocument()
                var user = try userDoc.data(as: User.self)
                user.score += 5
                let updatedUser = try Firestore.Encoder().encode(user)
                try await userRef.setData(updatedUser, merge: true)
                
            }
        }
        
    }
    
    
    static func unlikePost(post: Post, user: User) async throws {
        let postId = post.id
        let postUserId = post.userId
        let userId = user.id
        
        if postUserId != userId {
            let likeRef = Firestore.firestore().collection("posts").document(postId).collection("likes")
            let query = likeRef
                .whereField("userId", isEqualTo: userId)
            
            let querySnapshot = try await query.getDocuments()
            if let document = querySnapshot.documents.first {
                let docId = document.documentID
                
                try await likeRef.document(docId).delete()
                
                let docRef = Firestore.firestore().collection("posts").document(postId)
                let document = try await docRef.getDocument()
                var post = try document.data(as: Post.self)
                post.score -= 1
                let updatedData = try Firestore.Encoder().encode(post)
                try await docRef.setData(updatedData, merge: true)
                
                let userRef = Firestore.firestore().collection("users").document(postUserId)
                let userDoc = try await userRef.getDocument()
                var user = try userDoc.data(as: User.self)
                user.score -= 5
                let updatedUser = try Firestore.Encoder().encode(user)
                try await userRef.setData(updatedUser, merge: true)
            }
        }
    }
}
