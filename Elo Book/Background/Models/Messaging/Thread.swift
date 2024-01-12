//
//  Thread.swift
//  Elo Book
//
//  Created by Jed Kutai on 1/12/24.
//

import Foundation
import Firebase

struct Thread: Identifiable, Hashable, Codable {
    let id: String
    
    var ownerId: String
    
    var memberIds: [String]?
    var mutedByIds: [String]?
    var threadName: String?
    var imageId: String?
    var imageUrl: String?
    var timestamp: Timestamp = Timestamp()
    var lastMessageTimeStamp: Timestamp = Timestamp()
    
}


