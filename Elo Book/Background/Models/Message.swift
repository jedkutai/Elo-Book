//
//  Message.swift
//  EloBook
//
//  Created by Jed Kutai on 11/11/23.
//

import Foundation
import Firebase

struct Message: Identifiable, Hashable, Codable {
    let id: String
    let threadId: String
    let userId: String
    
    let messageType: String // either "standard" or "sharedPost" or "sharedProfile"
    
    var shareId: String // docId of the sharedPost or sharedProfile if not a share, set to empty string
    
    // sending a regular message
    var caption: String
    var imageUrls: [String]
    var imageIds: [String]
    var messageSeenBy: [String]
    
    var timestamp: Timestamp = Timestamp()
    
}

extension Message {
    static var MOCK_MESSAGE: Message = .init(id: "", threadId: "", userId: "", messageType: "", shareId: "", caption: "", imageUrls: [], imageIds: [], messageSeenBy: [])
}
