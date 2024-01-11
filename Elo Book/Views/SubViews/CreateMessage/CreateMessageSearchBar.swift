//
//  CreateMessageSearchBar.swift
//  Elo Book
//
//  Created by Jed Kutai on 1/10/24.
//

import SwiftUI

struct CreateMessageSearchBar: View {
    @Binding var searchText: String
    @Binding var user: User
    @Binding var usernameSearchResults: [User]
    @Binding var recievingUsers: [User]
    
    var body: some View {
        HStack {
            
            TextField("Find Users", text: $searchText, axis: .vertical)
                .autocapitalization(.none)
                .font(.footnote)
                
            Spacer()
        
        }
        .padding(10)
        .background(
            RoundedRectangle(cornerRadius: 15)
                .stroke(Color(.gray).opacity(0.3), lineWidth: 1)
        )
        .padding(.horizontal, 10)
        
        ForEach(usernameSearchResults, id: \.id) { searchUser in
            if searchUser.id != user.id && !recievingUsers.contains(where: { $0.id == searchUser.id }) {
                Button {
                    if recievingUsers.count < 50 {
                        recievingUsers.append(searchUser)
                        searchText = ""
                    }
                } label: {
                    VStack {
                        CreateMessageUserCell(user: searchUser)
                        Divider()
                            .frame(height: 1)
                    }
                }
            }
        }
    }
}
