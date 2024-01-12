//
//  Message2.swift
//  Elo Book
//
//  Created by Jed Kutai on 1/12/24.
//

import Foundation
import Firebase

struct Message2: Identifiable, Hashable, Codable {
    let id: String
    let threadId: String
    let userId: String
    
    // i can determine what kind of message it is by what field is filled
    var sharedPostId: String?
    var sharedUserId: String?
    var caption: String?
    
    // sending a regular message
    
    var imageUrls: [String]?
    var imageIds: [String]?
    var messageSeenBy: [String]?
    
    var timestamp: Timestamp = Timestamp()
    
}
