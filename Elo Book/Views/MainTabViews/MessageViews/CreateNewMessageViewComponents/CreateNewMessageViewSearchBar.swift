//
//  CreateNewMessageViewSearchBar.swift
//  Elo Book
//
//  Created by Jed Kutai on 1/12/24.
//

import SwiftUI

struct CreateNewMessageViewSearchBar: View {
    @Binding var searchText: String
    var body: some View {
        HStack {
            TextField("Find Users", text: $searchText, axis: .vertical)
                .autocapitalization(.none)
            
            Spacer()
        }
        .padding(10)
        .background(
            RoundedRectangle(cornerRadius: 15)
                .stroke(Color(.gray).opacity(0.3), lineWidth: 1)
        )
        .padding(.horizontal, 10)
    }
}

