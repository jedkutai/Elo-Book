//
//  SearchView2.swift
//  Elo Book
//
//  Created by Jed Kutai on 1/9/24.
//

import SwiftUI
import Firebase

struct SearchView2: View {
    @Binding var user: User
    
    @State var searchText = ""
    @State private var searchDatabaseText = ""
    
    
    @State private var filters: [String] = [] // create a usefavorites array
    
    let fourHoursAgo = Calendar.current.date(byAdding: .hour, value: -4, to: Date()) ?? Date()
    
    var displayedEvents: [Event] {
        guard !filters.isEmpty else { return x.events }
        return x.events.filter { event in
            return filters.contains(event.sport) && event.timestamp.dateValue() >= fourHoursAgo
        }
    }
    
    var filteredDiscoverEvents: [Event] {
        guard !searchText.isEmpty else { return displayedEvents }
        return x.events.filter { event in
            return event.title.localizedCaseInsensitiveContains(searchText) || event.sport.localizedCaseInsensitiveContains(searchText)
        }
    }
    
    var filteredUsers: [User] {
        guard !searchText.isEmpty else { return x.users }
        return x.users.filter { user in
            if let username = user.username {
                return username.localizedCaseInsensitiveContains(searchText)
            }
            return false
        }
    }
    
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
                        if !searchText.isEmpty {
                            ForEach(Array(filteredUsers.prefix(5)), id: \.id) { searchUser in
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
                        }
                        
                        ForEach(filteredDiscoverEvents, id: \.id) { event in
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
                .scrollDismissesKeyboard(.immediately)
                .refreshable {
                    
                    Task {
                        do {
                            filters = try await FetchService.fetchFavoriteSportsSettingsAsStringArray(user: user)
                        } catch {
                            filters = []
                        }
                        
                        user = try await FetchService.fetchUserById(withUid: user.id)
                    }
                }
            }
            .onAppear {
                Task {
                    do {
                        filters = try await FetchService.fetchFavoriteSportsSettingsAsStringArray(user: user)
                    } catch {
                        filters = []
                    }
                    
                    if x.firstEventSearch {
                        x.firstEventSearch.toggle()
                        x.events = try await FetchService.fetchRecentEvents()
                    }
                    user = try await FetchService.fetchUserById(withUid: user.id)
                }
            }
            .onTapGesture {
                hideKeyboard()
            }
            .onChange(of: searchText) {
                if searchText.count < 1 {
                    searchDatabaseText = ""
                } else if searchText.count >= 1 {
                    searchDatabaseText = String(searchText.prefix(2))
                }
                
                

            }
            .onChange(of: searchDatabaseText) {
                if !searchDatabaseText.isEmpty {
                    if Checks.isValidSearch(searchDatabaseText) {
                        Task {
                            let someUsers = try await SearchService.searchDatabaseForUsernames(searchTerm: searchDatabaseText)
                            x.users = x.mergeArraysAndRemoveDuplicates(x.users, someUsers, keyPath: \.id)
                        }
                    }
                }             }
            .onSubmit {
                hideKeyboard()
            }
            
        }
        .padding(.bottom, 1)
    }
}
