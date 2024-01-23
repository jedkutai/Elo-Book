//
//  ReplyLike.swift
//  Elo Book
//
//  Created by Jed Kutai on 1/22/24.
//

import Foundation
import Firebase
import FirebaseFirestore

struct ReplyLike: Identifiable, Hashable, Codable {
    let id: String
    
    let replyId: String
    let userId: String
    
    var timestamp: Timestamp = Timestamp()
    var notificationSeen: Bool?
}
