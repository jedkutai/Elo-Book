//
//  ReplyOnCommentAlert.swift
//  Elo Book
//
//  Created by Jed Kutai on 1/22/24.
//

import Foundation
import Firebase
import FirebaseFirestore

struct ReplyOnCommentAlert: Identifiable, Hashable, Codable {
    let id: String // reply Id
    let commentId: String
    let postId: String
    let userId: String
    
    var notificationSeen: Bool?
    
    var timestamp: Timestamp = Timestamp()
    
    
}
