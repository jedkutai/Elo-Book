//
//  UserBadgeSettings.swift
//  Elo Book
//
//  Created by Jed Kutai on 1/9/24.
//

import Foundation

struct UserBadgeSettings: Identifiable, Hashable, Codable {
    let id: String
    
    var publicFigure: Bool?
    var alphaTester: Bool?
    var degenerate: Bool?
    var firstHundred: Bool?
    
}
