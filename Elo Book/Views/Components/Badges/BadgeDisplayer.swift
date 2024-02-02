//
//  BadgeDisplayer.swift
//  Elo Book
//
//  Created by Jed Kutai on 1/9/24.
//

import SwiftUI

struct BadgeDisplayer: View {
    let badge: String
    
    var body: some View {
        if badge == "alphaTester" {
            AlphaTesterBadge()
        } else if badge == "degenerate" {
            DegenerateBadge()
        } else if badge == "publicFigure" {
            PublicFigureBadge()
        } else if badge == "firstHundred" {
            FirstHundredBadge()
        }
    }
}

