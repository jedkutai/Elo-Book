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
    var displayedBadge: String?
    var allBadges: [String]?
    var favorites: [String]?
    
    var score: Int = 0
    var timestamp: Timestamp = Timestamp()
}

extension User {
    static var MOCK_USER: User = .init(id: "MOCKID", email: "mockemail@email.com", dateOfBirth: Timestamp(), username: "mockusername", profileImageUrl: "", fullname: "Mock User", bio: "I'm a yankee doodle dandee")
}
