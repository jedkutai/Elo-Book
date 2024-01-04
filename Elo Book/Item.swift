//
//  Item.swift
//  Elo Book
//
//  Created by Jed Kutai on 1/4/24.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
