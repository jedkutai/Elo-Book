//
//  FirstHundredBadge.swift
//  Elo Book
//
//  Created by Jed Kutai on 1/25/24.
//

import SwiftUI

struct FirstHundredBadge: View {
    var body: some View {
        Menu {
            Text("First Hundred Users")
        } label: {
            Image(systemName: "checkmark.seal.fill")
                .foregroundStyle(Color(.purple))
                .font(.system(size: 15))
        }
    }
}
