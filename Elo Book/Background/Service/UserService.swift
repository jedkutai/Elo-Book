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
    
    static func blockUser(user: User, userToBlock: User) async throws {
        
        let blockRef = Firestore.firestore().collection("blocks")
        let query = blockRef
            .whereField("userId", isEqualTo: user.id)
            .whereField("userToBlockId", isEqualTo: userToBlock.id)
        
        let querySnapshot = try await query.getDocuments()
        
        if querySnapshot.documents.first == nil {
            let blockRef = Firestore.firestore().collection("blocks").document()
            
            let block = Block(id: blockRef.documentID, userId: user.id, userToBlockId: userToBlock.id)
            
            guard let encodedBlock = try? Firestore.Encoder().encode(block) else { return }
            
            try await blockRef.setData(encodedBlock)
            
            try await UserService.unFollowUser(userId: user.id, userToUnfollow: userToBlock.id)
            try await UserService.unFollowUser(userId: userToBlock.id, userToUnfollow: user.id)
        }
        
    }
    
    static func unblockUser(user: User, userToUnBlock: User) async throws {
        let blockRef = Firestore.firestore().collection("blocks")
        let query = blockRef
            .whereField("userId", isEqualTo: user.id)
            .whereField("userToBlockId", isEqualTo: userToUnBlock.id)
        
        let querySnapshot = try await query.getDocuments()
        
        if let document = querySnapshot.documents.first {
            let docId = document.documentID
            try await blockRef.document(docId).delete()
        }
    }
    
    
    static func acceptTermsOfService(user: User) async throws {
        try await Firestore.firestore().collection("users").document(user.id).updateData(["termsOfServiceV1": true])
    }
    
    static func updatePhoneNumber(uid: String, newPhoneNumber: String) async throws {
        try await Firestore.firestore().collection("users").document(uid).updateData(["phoneNumber": newPhoneNumber])
    }
    
    static func changeFullname(uid: String, newFullname: String) async throws {
        let userRef = Firestore.firestore().collection("users").document(uid)
        try await userRef.updateData(["fullname": newFullname])
    }
    
    static func changeBio(uid: String, newBio: String) async throws {
        let userRef = Firestore.firestore().collection("users").document(uid)
        try await userRef.updateData(["bio": newBio])
    }
    
    static func changeWebsite(uid: String, newLink: String) async throws {
        let userRef = Firestore.firestore().collection("users").document(uid)
        try await userRef.updateData(["website": newLink])
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
            user.score += 100
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
            
            try await followRef.document(docId).delete()
            
            let docRef = Firestore.firestore().collection("users").document(userToUnfollow)
            let document = try await docRef.getDocument()
            var user = try document.data(as: User.self)
            user.score -= 100
            let updatedData = try Firestore.Encoder().encode(user)
            try await docRef.setData(updatedData, merge: true)
        }
    }
    
    
    static func startUserNotificationSettings(user: User) async {
        let notificationSettings = UserNotificationSettings(id: user.id, followAlerts: true, likedPostAlerts: true, commentedPostAlerts: true, likedCommentAlerts: true, communityInviteAlerts: true, communityMessageAlerts: true)
        guard let encodedNotificationSettings = try? Firestore.Encoder().encode(notificationSettings) else { return }
        try? await Firestore.firestore().collection("users").document(user.id).collection("settings").document("notificationSettings").setData(encodedNotificationSettings)
    }
    
    static func updateUserNotificationSettings(user: User, followAlerts: Bool, likedPostAlerts: Bool, commentedPostAlerts: Bool, likedCommentAlerts: Bool, communityInviteAlerts: Bool, communityMessageAlerts: Bool) async {
        let notificationSettings = UserNotificationSettings(id: user.id, followAlerts: followAlerts, likedPostAlerts: likedPostAlerts, commentedPostAlerts: commentedPostAlerts, likedCommentAlerts: likedCommentAlerts, communityInviteAlerts: communityInviteAlerts, communityMessageAlerts: communityMessageAlerts)
        guard let encodedNotificationSettings = try? Firestore.Encoder().encode(notificationSettings) else { return }
        try? await Firestore.firestore().collection("users").document(user.id).collection("settings").document("notificationSettings").setData(encodedNotificationSettings)
    }
    
    static func startUserFavoriteSportsSettings(user: User) async throws {
        let favoriteSpotsSettings = UserFavoriteSports(id: user.id, baseball: true, basketball: true, football: true, hockey: true, soccer: true)
        guard let encodedNotificationSettings = try? Firestore.Encoder().encode(favoriteSpotsSettings) else { return }
        try? await Firestore.firestore().collection("users").document(user.id).collection("settings").document("favoriteSportsSettings").setData(encodedNotificationSettings)
    }
    
    static func updateUserFavoriteSportsSettings(user: User, baseball: Bool, basketball: Bool, football: Bool, hockey: Bool, soccer: Bool) async throws {
        let favoriteSpotsSettings = UserFavoriteSports(id: user.id, baseball: baseball, basketball: basketball, football: football, hockey: hockey, soccer: soccer)
        guard let encodedNotificationSettings = try? Firestore.Encoder().encode(favoriteSpotsSettings) else { return }
        try? await Firestore.firestore().collection("users").document(user.id).collection("settings").document("favoriteSportsSettings").setData(encodedNotificationSettings)
    }
    
    static func startUserBadges(user: User) async throws {
        let userBadges = UserBadgeSettings(id: user.id, publicFigure: false, alphaTester: false, degenerate: false, firstHundred: false)
        guard let encodedBadges = try? Firestore.Encoder().encode(userBadges) else { return }
        try? await Firestore.firestore().collection("users").document(user.id).collection("settings").document("badges").setData(encodedBadges)
    }
    
    static func updateDisplayedBadge(user: User, displayedBadge: String) async throws {
        let userRef = Firestore.firestore().collection("users").document(user.id)
        let data: [String: String] = ["displayedBadge": displayedBadge]
        try await userRef.setData(data, merge: true)
    }
    
    static func uploadFCMToken(user: User) async throws {
        let userRef = Firestore.firestore().collection("users").document(user.id)
        if let fcmToken = UserDefaults.standard.string(forKey: "fcmToken") {
            let data: [String: String] = ["fcmToken": fcmToken]
            guard let encodedToken = try? Firestore.Encoder().encode(data) else { return }
            try await userRef.setData(encodedToken, merge: true)
        }
    }
}
