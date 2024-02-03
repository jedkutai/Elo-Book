//
//  CommunityService.swift
//  Elo Book
//
//  Created by Jed Kutai on 2/3/24.
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseFirestore

struct CommunityService {
    static func createCommunity(user: User, communityName: String) async throws {
        let communityRef = Firestore.firestore().collection("communities").document()
        
        let communityId = communityRef.documentID
        
        let communityDisplayName = communityName.trimmingCharacters(in: .whitespacesAndNewlines)
        let communityNameLowercased = communityDisplayName.lowercased()
        let userId = user.id
        
        let newCommuntiy = Community(id: communityId, communityName: communityNameLowercased, communityDisplayName: communityDisplayName, ownerId: userId, memberIds: [userId])
        
        guard let encodedCommunity = try? Firestore.Encoder().encode(newCommuntiy) else { return }
        try? await communityRef.setData(encodedCommunity)
        
        let userRef = Firestore.firestore().collection("users").document(userId)
        let userDoc = try await userRef.getDocument()
        var user = try userDoc.data(as: User.self)
        
        // update communitesmade count
        if let communitiesMade = user.communitiesMade {
            user.communitiesMade = communitiesMade + 1
        } else {
            user.communitiesMade = 1
        }
        
        // update array of community ids
        if let communities = user.communities {
            var updatedCommunites = communities + [communityId]
            updatedCommunites.sort()
            user.communities = updatedCommunites
        } else {
            user.communities = [communityId]
        }
        
        
        let updatedUser = try Firestore.Encoder().encode(user)
        try await userRef.setData(updatedUser, merge: true)
    }
    

}
