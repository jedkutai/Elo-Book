//
//  PublicFigureBadge.swift
//  Elo Book
//
//  Created by Jed Kutai on 1/9/24.
//

import SwiftUI

struct PublicFigureBadge: View {
    var body: some View {
        Menu {
            Text("Public Figure")
        } label: {
            Image(systemName: "checkmark.seal.fill")
                .foregroundStyle(Color(.blue))
                .font(.system(size: 15))
        }
    }
}
