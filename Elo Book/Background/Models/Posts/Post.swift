//
//  Post.swift
//  Elo
//
//  Created by Jed Kutai on 12/16/23.
//

import Foundation
import Firebase
import FirebaseFirestore

struct Post: Identifiable, Hashable, Codable {
    let id: String
    let userId: String
    
    var caption: String?
    var imageUrls: [String]?
    var imageIds: [String]?
    var eventIds: [String]?
    var timestamp: Timestamp = Timestamp()
    
    var score: Int = 0
    
}

extension Post {
    static var MOCK_POST: Post = .init(id: "mockid", userId: "mockuserid", caption: "mock caption", imageUrls: [], imageIds: [], eventIds: [])
}
