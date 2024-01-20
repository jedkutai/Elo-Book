//
//  ReportPost.swift
//  Elo Book
//
//  Created by Jed Kutai on 1/18/24.
//

import Foundation
import Firebase
import FirebaseFirestore

struct ReportPost: Identifiable, Hashable, Codable {
    let id: String
    
    let postId: String
    let posterId: String
    let reporterId: String
    
    var harassment: Bool?
    var violence: Bool?
    var nudity: Bool?
    var scam: Bool?
    var slurs: Bool?
    var impersonation: Bool?
    var other: Bool?
    
    var additionalComments: String?
    
    var timestamp: Timestamp = Timestamp()
}


