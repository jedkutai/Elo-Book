//
//  UserFavoriteSports.swift
//  Elo Book
//
//  Created by Jed Kutai on 1/9/24.
//

import Foundation

struct UserFavoriteSports: Identifiable, Hashable, Codable {
    let id: String
    var baseball: Bool?
    var basketball: Bool?
    var football: Bool?
    var hockey: Bool?
    var soccer: Bool?
    
}
