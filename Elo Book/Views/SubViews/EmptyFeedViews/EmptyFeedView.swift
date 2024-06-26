//
//  EmptyFeedView.swift
//  EloBookv1
//
//  Created by Jed Kutai on 1/3/24.
//

import SwiftUI

struct EmptyFeedView: View {
    @State var user: User
    @Binding var emptyUsers: [User]
    
    var body: some View {
        NavigationStack {
            HStack {
                Spacer()
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(emptyUsers, id: \.id) { viewedUser in
                            NavigationLink {
                                AltUserProfileView(user: user, viewedUser: viewedUser)
                            } label: {
                                EmptyFeedUserCell(user: user, viewedUser: viewedUser)
                            }
                                
                        }
                    }
                }
                .padding(.horizontal)
                
                Spacer()
            }
        }
        .onAppear {
            Task {
                emptyUsers = try await FetchService.fetchEmptyFeedUsers(user: user)
            }
        }
        
    }

}
