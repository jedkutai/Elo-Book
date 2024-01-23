//
//  ReportComment.swift
//  Elo Book
//
//  Created by Jed Kutai on 1/21/24.
//

import Foundation
import Firebase
import FirebaseFirestore

struct ReportComment: Identifiable, Hashable, Codable {
    let id: String
    
    let postId: String
    let commentId: String
    let commenterId: String
    let reporterId: String
    
    var harassment: Bool?
    var violence: Bool?
    var scam: Bool?
    var slurs: Bool?
    var impersonation: Bool?
    var other: Bool?
    
    var additionalComments: String?
    
    var timestamp: Timestamp = Timestamp()
}
