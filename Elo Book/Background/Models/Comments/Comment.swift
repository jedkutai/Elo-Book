//
//  Comment.swift
//  Elo
//
//  Created by Jed Kutai on 12/16/23.
//

import Foundation
import Firebase
import FirebaseFirestore

struct Comment: Identifiable, Hashable, Codable {
    let id: String
    let postId: String
    let userId: String
    
    var caption: String?
    var taggedUsers: [String]?
    
    var score: Int = 0
    var timestamp: Timestamp = Timestamp()
    var notificationSeen: Bool?
}

extension Comment {
    static var MOCK_COMMENT: Comment = .init(id: "commentid", postId: "postid", userId: "userid", caption: "Caption")
}
