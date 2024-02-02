//
//  Community.swift
//  Elo Book
//
//  Created by Jed Kutai on 1/26/24.
//

import Foundation
import Firebase

struct Community: Identifiable, Hashable, Codable {
    let id: String
    var communityName: String
    var ownerId: String
    
    var memberIds: [String]
    var memberCount: Int = 1
    
    var imageId: String?
    var imageUrl: String?
    var timestamp: Timestamp = Timestamp()
    
}
