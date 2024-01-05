//
//  Team.swift
//  EloBook
//
//  Created by Jed Kutai on 11/30/23.
//

import Foundation
import Firebase

struct Team: Identifiable, Hashable, Codable {
    let id: String
    let teamName: String
    let sport: String
    let country: String
    let teamLogo: String
    let teamNameSearchable: [String]
    let sportSearchable: [String]
    let countrySearchable: [String]
}
