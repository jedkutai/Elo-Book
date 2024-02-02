//
//  AlphaTesterBadge.swift
//  Elo Book
//
//  Created by Jed Kutai on 1/9/24.
//

import SwiftUI

struct AlphaTesterBadge: View {
    var body: some View {
        Menu {
            Text("Alpha Tester")
        } label: {
            Image(systemName: "checkmark.seal.fill")
                .foregroundStyle(Color(.red))
                .font(.system(size: 15))
        }
            
    }
}
