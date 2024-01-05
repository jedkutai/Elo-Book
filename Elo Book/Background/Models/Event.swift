//
//  Event.swift
//  EloBook
//
//  Created by Jed Kutai on 11/12/23.
//

import Foundation
import Firebase
import FirebaseFirestore

struct Event: Identifiable, Hashable, Codable {
    let id: String
    var timestamp: Timestamp = Timestamp()
    
    var title: String // Team1 vs Team2
    var sport: String
    
    var team1: String
    var team2: String
    
    var team1_ID: String
    var team2_ID: String
    
}
