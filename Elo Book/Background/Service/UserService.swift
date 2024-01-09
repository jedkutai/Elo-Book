//
//  UserService.swift
//  Elo
//
//  Created by Jed Kutai on 12/16/23.
//

import Foundation
import Firebase
import FirebaseFirestore

struct UserService {
    static func changeFullname(uid: String, newFullname: String) async throws {
        let userRef = Firestore.firestore().collection("users").document(uid)
        try await userRef.updateData(["fullname": newFullname])
    }
    
    static func changeBio(uid: String, newBio: String) async throws {
        let userRef = Firestore.firestore().collection("users").document(uid)
        try await userRef.updateData(["bio": newBio])
    }
    
    static func changeProfileImage(uid: String, newProfileImageUrl: String) async throws {
        let userRef = Firestore.firestore().collection("users").document(uid)
        try await userRef.updateData(["profileImageUrl": newProfileImageUrl])
    }
    
    static func followUser(userId: String, userToFollowId: String) async throws {
        let query = Firestore.firestore().collection("follows")
            .whereField("followingId", isEqualTo: userToFollowId)
            .whereField("followerId", isEqualTo: userId)
        
        let querySnapshot = try await query.getDocuments()
        
        if querySnapshot.documents.first == nil {
            let followRef = Firestore.firestore().collection("follows").document()
            let docId = followRef.documentID
            
            let follow = Follow(id: docId, followerId: userId, followingId: userToFollowId)
            guard let encodedFollow = try? Firestore.Encoder().encode(follow) else { return }
            
            try await followRef.setData(encodedFollow)
            
            let docRef = Firestore.firestore().collection("users").document(userToFollowId)
            let document = try await docRef.getDocument()
            var user = try document.data(as: User.self)
            user.score += 1
            let updatedData = try Firestore.Encoder().encode(user)
            try await docRef.setData(updatedData, merge: true)
        }
        
    }
    
    static func unFollowUser(userId: String, userToUnfollow: String) async throws {
        let followRef = Firestore.firestore().collection("follows")
        let query = followRef
            .whereField("followerId", isEqualTo: userId)
            .whereField("followingId", isEqualTo: userToUnfollow)
        
        let querySnapshot = try await query.getDocuments()
        if let document = querySnapshot.documents.first {
            let docId = document.documentID
            
            let followingRef = Firestore.firestore().collection("users").document(userId).collection("following").document(docId)
            let followersRef = Firestore.firestore().collection("users").document(userToUnfollow).collection("followers").document(docId)
            
            try await followRef.document(docId).delete()
            try await followingRef.delete()
            try await followersRef.delete()
            
            let docRef = Firestore.firestore().collection("users").document(userToUnfollow)
            let document = try await docRef.getDocument()
            var user = try document.data(as: User.self)
            user.score -= 1
            let updatedData = try Firestore.Encoder().encode(user)
            try await docRef.setData(updatedData, merge: true)
        }
    }
    
    static func updateUserFavorites(user: User, favorites: [String]) async throws {
        let userRef = Firestore.firestore().collection("users").document(user.id)
        let data: [String: Any] = ["favorites": favorites]
        try await userRef.setData(data, merge: true)
    }
    
    static func startUserNotificationSettings(user: User) async {
        let notificationSettings = UserNotificationSettings(id: user.id, followAlerts: true, likedPostAlerts: true, commentedPostAlerts: true, likedCommentAlerts: true, communityInviteAlerts: true, communityMessageAlerts: true)
        guard let encodedNotificationSettings = try? Firestore.Encoder().encode(notificationSettings) else { return }
        try? await Firestore.firestore().collection("users").document(user.id).collection("settings").document("notificationSettings").setData(encodedNotificationSettings)
    }
    
}
