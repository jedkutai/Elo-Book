//
//  User.swift
//  Elo
//
//  Created by Jed Kutai on 12/15/23.
//

import Foundation
import Firebase
import FirebaseFirestore

struct User: Identifiable, Hashable, Codable {
    let id: String
    var email: String
    var dateOfBirth: Timestamp
    
    var privateAccount: Bool?
    var username: String?
    var profileImageUrl: String?
    var profileImageId: String?
    var fullname: String?
    var bio: String?
    var phoneNumber: String?
    var displayedBadge: String?
    var fcmToken: String?
    var termsOfServiceV1: Bool?
    var communities: Int?
    var website: String?
    
    var score: Int = 0
    var timestamp: Timestamp = Timestamp()
}

extension User {
    static var MOCK_USER: User = .init(id: "", email: "", dateOfBirth: Timestamp(), username: "", profileImageUrl: "", fullname: "", bio: "")
}
