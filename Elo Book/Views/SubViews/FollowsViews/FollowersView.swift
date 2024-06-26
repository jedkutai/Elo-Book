//
//  FollowersView.swift
//  Elo Book
//
//  Created by Jed Kutai on 1/6/24.
//

import SwiftUI

struct FollowersView: View {
    @State var user: User
    @State var viewedUser: User
    
    @State private var followers: [User] = []
    @State private var searchText: String = ""
    @State private var swipeStarted = false
    @State private var degenerating = true
    
    
    var filteredFollowers: [User] {
        guard !searchText.isEmpty else { return followers }
        return followers.filter { user in
            if let username = user.username {
                return username.localizedCaseInsensitiveContains(searchText)
            }
            return false
        }
    }

    
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.dismiss) private var dismiss

    
    var body: some View {
        if degenerating {
            VStack {
                ProgressView("Degenerating...")
            }
            .onAppear {
                Task {
                    do {
                        followers = try await FetchService.fetchFollowersByUser(user: viewedUser)
                        degenerating  = false
                    } catch {
                        degenerating = false
                    }
                }
            }
        } else {
            NavigationStack {
                ScrollView(.vertical) {
                    LazyVStack {
                        // search bar
                        HStack {
                            
                            HStack {
                                Image(systemName: "magnifyingglass")
                                    .foregroundColor(.gray)
                                
                                TextField("Search Followers", text: $searchText)
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
                        .padding(.vertical, 10)
                        
                        // followers
                        ForEach(filteredFollowers, id: \.id) { follower in
                            NavigationLink {
                                AltUserProfileView(user: user, viewedUser: follower)
                            } label: {
                                FollowsResultCell(user: user, viewedUser: follower)
                            }
                            
                        }
                    }
                    
                }
                .padding(.horizontal, 10)
                .scrollDismissesKeyboard(.immediately)
                .refreshable {
                    Task {
                        followers = try await FetchService.fetchFollowersByUser(user: viewedUser)
                    }
                }
                .navigationTitle("Followers")
                .toolbarTitleDisplayMode(.inline)
                
            }
        }
    }
}

