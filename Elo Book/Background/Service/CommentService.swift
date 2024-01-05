//
//  CommentService.swift
//  Elo
//
//  Created by Jed Kutai on 12/16/23.
//

import Foundation
import Firebase
import FirebaseFirestore

struct CommentService {
    static func deleteComment(comment: Comment) async throws {
        // delete comment
        let commentRef = Firestore.firestore().collection("posts").document(comment.postId).collection("comments").document(comment.id)
        try await commentRef.delete()
        
        let docRef = Firestore.firestore().collection("posts").document(comment.postId)
        let document = try await docRef.getDocument()
        var post = try document.data(as: Post.self)
        post.score -= 3
        let updatedData = try Firestore.Encoder().encode(post)
        try await docRef.setData(updatedData, merge: true)
        
//        let query = Firestore.firestore().collection("posts").document(comment.postId).collection("commentLikes")
//        
//        let snapshot = try await query.getDocuments()
//        
//        for document in snapshot.documents {
//            let docRef = Firestore.firestore().collection("commentLikes").document(document.documentID)
//            try await docRef.delete()
//        }
        
    }
    
    static func likeComment(comment: Comment, userId: String) async throws {
        let commentLikeRef1 = Firestore.firestore().collection("posts").document(comment.postId).collection("comments").document(comment.id).collection("commentLikes")
        let query = commentLikeRef1
            .whereField("userId", isEqualTo: userId)
        
        let querySnapshot = try await query.getDocuments()
        if querySnapshot.documents.first != nil {
            
        } else {
            let commentLikeRef = Firestore.firestore().collection("posts").document(comment.postId).collection("comments").document(comment.id).collection("commentLikes").document()
            
            let commentLike = CommentLike(id: commentLikeRef.documentID, commentId: comment.id, userId: userId)
            guard let encodedCommentLike = try? Firestore.Encoder().encode(commentLike) else { return }
            try await commentLikeRef.setData(encodedCommentLike)
            
            let docRef = Firestore.firestore().collection("posts").document(comment.postId).collection("comments").document(comment.id)
            let document = try await docRef.getDocument()
            var comment = try document.data(as: Comment.self)
            comment.score += 1
            let updatedData = try Firestore.Encoder().encode(comment)
            try await docRef.setData(updatedData, merge: true)
        }
        
    }
    
    
    static func unlikeComment(comment: Comment, userId: String) async throws {
        let commentLikeRef = Firestore.firestore().collection("posts").document(comment.postId).collection("comments").document(comment.id).collection("commentLikes")
        let query = commentLikeRef
            .whereField("userId", isEqualTo: userId)
        
        let querySnapshot = try await query.getDocuments()
        if let document = querySnapshot.documents.first {
            try await commentLikeRef.document(document.documentID).delete()
            
            // reduce score of comment
            let docRef = Firestore.firestore().collection("posts").document(comment.postId).collection("comments").document(comment.id)
            let document = try await docRef.getDocument()
            var comment = try document.data(as: Comment.self)
            comment.score -= 1
            let updatedData = try Firestore.Encoder().encode(comment)
            try await docRef.setData(updatedData, merge: true)
        }
        
        
    }
}
