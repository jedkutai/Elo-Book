//
//  CommentLike.swift
//  Elo
//
//  Created by Jed Kutai on 12/16/23.
//

import Foundation
import Firebase
import FirebaseFirestore

struct CommentLike: Identifiable, Hashable, Codable {
    let id: String
    
    let commentId: String
    let userId: String
    
    var timestamp: Timestamp = Timestamp()
    
}
