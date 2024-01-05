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
        
//        // delete comments
//        let comments = try await FetchService.fetchCommentsByPostId(postId: post.id)
//        for comment in comments {
//            try await CommentService.deleteComment(comment: comment)
//        }
//        
//        if let imageIds = post.imageIds { // delete image
//            for imageId in imageIds {
//                let ref = Storage.storage().reference(withPath: "/\(post.userId)/post_images/\(imageId)")
//                try await ref.delete()
//            }
//        }
        
    }
    
    
    static func likePost(postId: String, userId: String) async throws {
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
        }
        
    }
    
    
    static func unlikePost(postId: String, userId: String) async throws {
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
        }
    }
}
