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
    @State private var someUsers: [User] = []
    
    let fourHoursAgo = Calendar.current.date(byAdding: .hour, value: -4, to: Date()) ?? Date()
    let fiveHoursAgo = Calendar.current.date(byAdding: .hour, value: -6, to: Date()) ?? Date()
    
    var displayedEvents: [Event] {
        guard !filters.isEmpty else { return x.events }
        return x.events.filter { event in
            return filters.contains(event.sport) && event.timestamp.dateValue() >= fourHoursAgo
        }
    }
    
    var filteredDiscoverEvents: [Event] {
        guard !searchText.isEmpty else { return displayedEvents }
        return x.events.filter { event in
            return (event.title.localizedCaseInsensitiveContains(searchText) || event.sport.localizedCaseInsensitiveContains(searchText)) && event.timestamp.dateValue() >= fiveHoursAgo
        }
    }
    

    var filteredUsers: [User] {
        guard !searchText.isEmpty else { return someUsers }
        return someUsers.filter { user in
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
                
                ScrollView(.vertical, showsIndicators: false) {
                    VStack {
                        if !searchText.isEmpty {
                            ForEach(Array(filteredUsers.prefix(5)), id: \.id) { searchUser in
                                NavigationLink {
                                    AltUserProfileView(user: user, viewedUser: searchUser)
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
                                EventView(user: user, event: event)
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
            .padding(.vertical, 10)
        }
        .padding(.vertical, 10)
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
                        someUsers = try await SearchService.searchDatabaseForUsernames(searchTerm: searchDatabaseText)
                    }
                }
            }
        }
        .onSubmit {
            hideKeyboard()
        }
            
    }
        
}

