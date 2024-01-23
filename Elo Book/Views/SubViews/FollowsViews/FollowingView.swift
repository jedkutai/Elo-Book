//
//  FollowingView.swift
//  Elo Book
//
//  Created by Jed Kutai on 1/6/24.
//

import SwiftUI

struct FollowingView: View {
    @State var user: User
    @State var viewedUser: User
    
    @State private var following: [User] = []
    @State private var searchText: String = ""
    @State private var swipeStarted = false
    
    var filteredFollowers: [User] {
        guard !searchText.isEmpty else { return following }
        return following.filter { user in
            if let username = user.username {
                return username.localizedCaseInsensitiveContains(searchText)
            }
            return false
        }
    }

    
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            LazyVStack {
                
                HStack {
                    
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                        
                        TextField("Search Following", text: $searchText)
                            .padding(.vertical, 2.5)
                            .autocapitalization(.none)
                            .onSubmit {
                                hideKeyboard()
                            }
                        
                        Spacer()
                        
                        if !searchText.isEmpty {
                            Button {
                                searchText = ""
                            } label: {
                                Image(systemName: "x.circle.fill")
                                    .foregroundColor(.gray)
                            }
                        }
                    
                    }
                    .padding(5)
                    .background(
                        RoundedRectangle(cornerRadius: 15)
                            .stroke(Color(.gray).opacity(0.3), lineWidth: 1)
                    )
                    
                }
                .padding(.horizontal)
                
                ScrollView {
                    ForEach(filteredFollowers, id: \.id) { following in
                        NavigationLink {
                            AltUserProfileView(user: user, viewedUser: following)
                        } label: {
                            FollowsResultCell(user: user, viewedUser: following)
                        }
                        
                    }
                    Spacer()
                }
                .padding()
                .scrollDismissesKeyboard(.immediately)
                .refreshable {
                    Task {
                        following = try await FetchService.fetchFollowingByUser(user: viewedUser)
                    }
                }
                
                
            }
            .navigationTitle("Following")
            .toolbarTitleDisplayMode(.inline)
            .onAppear {
                Task {
                    following = try await FetchService.fetchFollowingByUser(user: viewedUser)
                }
            }
            
            Spacer()
            
        }
    }
}
