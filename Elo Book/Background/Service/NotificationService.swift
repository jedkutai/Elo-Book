//
//  NotificationService.swift
//  Elo Book
//
//  Created by Jed Kutai on 1/10/24.
//

import Foundation
import Firebase
import FirebaseFirestore
import FirebaseMessaging


struct NotificationService {
    
    static func followAlertSeen(user: User, follow: Follow) async throws {
        let docRef = Firestore.firestore().collection("follows").document(follow.id)
        let snapshot = try await docRef.getDocument()
        var freshFollow = try snapshot.data(as: Follow.self)
        freshFollow.notificationSeen = true
        let updatedData = try Firestore.Encoder().encode(freshFollow)
        try await docRef.setData(updatedData, merge: true)
    }
    
    static func commentOnPostAlertSeen(user: User, commentAlert: CommentOnPostAlert) async throws {
        let commentOnPostRef = Firestore.firestore().collection("users").document(user.id).collection("commentOnPostAlerts").document(commentAlert.id)
        
        let snapshot = try await commentOnPostRef.getDocument()
        var freshAlert = try snapshot.data(as: CommentOnPostAlert.self)
        freshAlert.notificationSeen = true
        let updatedData = try Firestore.Encoder().encode(freshAlert)
        try await commentOnPostRef.setData(updatedData, merge: true)
        
    }
    
    static func replyOnCommentAlertSeen(user: User, replyAlert: ReplyOnCommentAlert) async throws {
        let replyOnCommentRef = Firestore.firestore().collection("users").document(user.id).collection("replyOnCommentAlerts").document(replyAlert.id)
        
        let snapshot = try await replyOnCommentRef.getDocument()
        var freshAlert = try snapshot.data(as: ReplyOnCommentAlert.self)
        freshAlert.notificationSeen = true
        let updatedData = try Firestore.Encoder().encode(freshAlert)
        try await replyOnCommentRef.setData(updatedData, merge: true)
        
    }
    
}
    

