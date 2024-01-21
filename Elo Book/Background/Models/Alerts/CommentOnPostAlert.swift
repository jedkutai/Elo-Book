//
//  CommentOnPostAlert.swift
//  Elo Book
//
//  Created by Jed Kutai on 1/20/24.
//

import Foundation
import Firebase
import FirebaseFirestore

struct CommentOnPostAlert: Identifiable, Hashable, Codable {
    let id: String // comment Id
    let postId: String
    let userId: String
    
    var notificationSeen: Bool?
    
    var timestamp: Timestamp = Timestamp()
    
    
}
