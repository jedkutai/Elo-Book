//
//  PostLike.swift
//  Elo
//
//  Created by Jed Kutai on 12/16/23.
//

import Foundation
import Firebase
import FirebaseFirestore

struct PostLike: Identifiable, Hashable, Codable {
    let id: String
    
    let postId: String
    let userId: String
    
    var timestamp: Timestamp = Timestamp()
    var notificationSeen: Bool?
}
