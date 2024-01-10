//
//  DegenerateBadge.swift
//  Elo Book
//
//  Created by Jed Kutai on 1/9/24.
//

import SwiftUI

struct DegenerateBadge: View {
    var body: some View {
        Image(systemName: "checkmark.seal.fill")
            .foregroundStyle(Color(.green))
            .font(.system(size: 15))
    }
}

