//
//  UploadReply.swift
//  Elo Book
//
//  Created by Jed Kutai on 1/22/24.
//

import Foundation
import PhotosUI
import SwiftUI
import Firebase
import FirebaseFirestore
import UIKit


@MainActor
class UploadReply: ObservableObject {
    
    
    func uploadReply(user: User, comment: Comment, caption: String) async throws {
        let replyRef = Firestore.firestore()
            .collection("posts").document(comment.postId)
            .collection("comments").document(comment.id)
            .collection("replies").document()
        
        let replyDocId = replyRef.documentID
        
        let reply = Reply(id: replyDocId, commentId: comment.id, postId: comment.postId, userId: user.id, caption: caption)
        guard let encodedReply = try? Firestore.Encoder().encode(reply) else { return }
        
        try await replyRef.setData(encodedReply)
        
        let docRef = Firestore.firestore().collection("posts").document(comment.postId).collection("comments").document(comment.id)
        let document = try await docRef.getDocument()
        var commentToUpdate = try document.data(as: Comment.self)
        commentToUpdate.score += 3
        
        let updatedData = try Firestore.Encoder().encode(commentToUpdate)
        try await docRef.setData(updatedData, merge: true)
        
        if comment.userId != user.id {
            let replyOnCommentRef = Firestore.firestore().collection("users").document(comment.userId).collection("replyOnCommentAlerts").document(replyDocId)
            
            let alert = ReplyOnCommentAlert(id: replyDocId, commentId: comment.id, postId: comment.postId, userId: user.id)
            guard let encodedAlert = try? Firestore.Encoder().encode(alert) else { return }
            
            try await replyOnCommentRef.setData(encodedAlert)
        }
        
        
    }

}
