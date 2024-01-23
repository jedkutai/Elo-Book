//
//  Block.swift
//  Elo Book
//
//  Created by Jed Kutai on 1/23/24.
//

import Foundation
import Firebase
import FirebaseFirestore

struct Block: Identifiable, Hashable, Codable {
    let id: String
    let userId: String
    let userToBlockId: String
}
