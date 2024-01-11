//
//  Thread.swift
//  EloBook
//
//  Created by Jed Kutai on 12/9/23.
//

import Foundation
import Firebase

struct Thread: Identifiable, Hashable, Codable {
    let id: String
    let founderId: String
    
    var userIds: [String]
    
    var mutedBy: [String]?
    var threadName: String?
    var imageId: String?
    var imageUrl: String?
    
    var timestamp: Timestamp = Timestamp()
    var lastMessageTimeStamp: Timestamp?
    var lastMessageId: String?
    
}
