//
//  Follow.swift
//  Elo
//
//  Created by Jed Kutai on 12/16/23.
//

import Foundation
import Firebase
import FirebaseFirestore

struct Follow: Identifiable, Hashable, Codable {
    let id: String
    
    // PersonA is following PersonB
    let followerId: String // A
    let followingId: String // B
    
    var timestamp: Timestamp = Timestamp()
    
    var notificationSeen: Bool?
}
