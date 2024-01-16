//
//  Chat.swift
//  Elo Book
//
//  Created by Jed Kutai on 1/15/24.
//

import Foundation
import Firebase

struct Chat: Identifiable, Hashable, Codable {
    let id: String
    let eventId: String
    let userId: String
    
    let username: String?
    var displayedBadge: String?
    let caption: String?
    
    
    var timestamp: Timestamp = Timestamp()
    
}
