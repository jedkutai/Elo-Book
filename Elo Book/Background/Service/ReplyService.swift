//
//  ReplyService.swift
//  Elo Book
//
//  Created by Jed Kutai on 1/22/24.
//

import Foundation
import Firebase
import FirebaseFirestore

struct ReplyService {
    
    static func likeReply(reply: Reply, user: User) async throws {
        let replyLikeRef1 = Firestore.firestore()
            .collection("posts").document(reply.postId)
            .collection("comments").document(reply.commentId)
            .collection("replies").document(reply.id)
            .collection("replyLikes")
        
        let query = replyLikeRef1
            .whereField("userId", isEqualTo: user.id)
        
        let querySnapshot = try await query.getDocuments()
        if querySnapshot.documents.first != nil {
            
        } else {
            let replyLikeRef = replyLikeRef1.document()
            
            let replyLike = ReplyLike(id: replyLikeRef.documentID, replyId: reply.id, userId: user.id)
            guard let encodedReplyLike = try? Firestore.Encoder().encode(replyLike) else { return }
            try await replyLikeRef.setData(encodedReplyLike)
        }
        
    }
    
    static func unlikeReply(reply: Reply, user: User) async throws {
        let replyLikeRef = Firestore.firestore()
            .collection("posts").document(reply.postId)
            .collection("comments").document(reply.commentId)
            .collection("replies").document(reply.id)
            .collection("replyLikes")
        
        let query = replyLikeRef
            .whereField("userId", isEqualTo: user.id)
        
        let querySnapshot = try await query.getDocuments()
        if let document = querySnapshot.documents.first {
            try await replyLikeRef.document(document.documentID).delete()
        }
        
    }
    
    
    static func deleteReply(reply: Reply) async throws {
        let replyRef = Firestore.firestore()
            .collection("posts").document(reply.postId)
            .collection("comments").document(reply.commentId)
            .collection("replies").document(reply.id)
        
        try await replyRef.delete()
        
        let docRef = Firestore.firestore()
            .collection("posts").document(reply.postId)
            .collection("comments").document(reply.commentId)
        
        let document = try await docRef.getDocument()
        var comment = try document.data(as: Comment.self)
        comment.score -= 3
        let updatedData = try Firestore.Encoder().encode(comment)
        try await docRef.setData(updatedData, merge: true)
    }
    
    
    
}
