//
//  Reply.swift
//  Elo Book
//
//  Created by Jed Kutai on 1/22/24.
//

import Foundation
import Firebase
import FirebaseFirestore

struct Reply: Identifiable, Hashable, Codable {
    let id: String
    let commentId: String
    let postId: String
    let userId: String
    
    var caption: String?
    var taggedUsers: [String]?
    
    var timestamp: Timestamp = Timestamp()
    var notificationSeen: Bool?
}
