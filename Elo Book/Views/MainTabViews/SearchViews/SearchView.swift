//
//  SearchView.swift
//  EloBookv1
//
//  Created by Jed Kutai on 12/24/23.
//

import SwiftUI

struct SearchView: View {
    @Binding var user: User
    
    @State var searchText = ""
    @State private var searchDatabaseText = ""
    
    @State private var someUsers: [User] = []
    @State private var allEvents: [Event] = []
    @State private var usernameSearchResults: [User] = []
    @State private var eventSearchResults: [Event] = []
    @State private var discoverEvents: [Event] = []
    
    @State private var followedTeams: [Team] = []
    
    @EnvironmentObject var x: X
    @Environment(\.dismiss) private var dismiss
    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                        
                        TextField("Search", text: $searchText)
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
                
                ScrollView(.vertical, showsIndicators: false) {
                    LazyVStack {
                        if searchText.isEmpty {
                            ForEach(discoverEvents, id: \.id) { event in
                                NavigationLink {
                                    EventView(user: user, event: event).navigationBarBackButtonHidden()
                                } label: {
                                    VStack {
                                        EventCell(event: event)
                                        Divider()
                                            .frame(height: 1)
                                    }
                                }
                            }
                        } else {
                            ForEach(usernameSearchResults, id: \.id) { searchUser in
                                NavigationLink {
                                    AltUserProfileView(user: user, viewedUser: searchUser).navigationBarBackButtonHidden()
                                } label: {
                                    VStack {
                                        UserResultCell(user: searchUser)
                                        Divider()
                                            .frame(height: 1)
                                    }
                                }
                            }
                            
                            ForEach(eventSearchResults, id: \.id) { event in
                                NavigationLink {
                                    EventView(user: user, event: event).navigationBarBackButtonHidden()
                                } label: {
                                    VStack {
                                        EventCell(event: event)
                                        Divider()
                                            .frame(height: 1)
                                    }
                                }
                            }
                            
                        }
                    }
                    
                }
                .scrollDismissesKeyboard(.immediately)
                .refreshable {
                    Task {
                        user = try await FetchService.fetchUserById(withUid: user.id)
                        discoverEvents = try await FetchService.fetchUserFavorites(user: user)
                    }
                }
            }
            .onAppear {
                Task {
                    if x.firstEventSearch {
                        x.firstEventSearch.toggle()
                        x.events = try await FetchService.fetchRecentEvents()
                    }
                    user = try await FetchService.fetchUserById(withUid: user.id)
                    discoverEvents = try await FetchService.fetchUserFavorites(user: user)
                }
            }
            .onTapGesture {
                hideKeyboard()
            }
            .onChange(of: searchText) {
                if searchText.count < 1 {
                    searchDatabaseText = ""
                    usernameSearchResults = []
                } else if searchText.count >= 1 {
                    searchDatabaseText = String(searchText.prefix(2))
                }
                
                usernameSearchResults = SearchService.searchLocallyForUsernames(searchText: searchText, users: x.users, limit: 10)
                eventSearchResults = SearchService.searchLocallyForEvents(in: x.events, for: searchText)

            }
            .onChange(of: searchDatabaseText) {
                if !searchDatabaseText.isEmpty {
                    if Checks.isValidSearch(searchDatabaseText) {
                        Task {
                            someUsers = try await SearchService.searchDatabaseForUsernames(searchTerm: searchDatabaseText)
                            x.users = x.mergeArraysAndRemoveDuplicates(x.users, someUsers, keyPath: \.id)
                        }
                    } else {
                        someUsers = []
                    }
                } else {
                    someUsers = []
                }
            }
            .onSubmit {
                hideKeyboard()
            }
            
        }
        .padding(.bottom, 1)
    }
}
