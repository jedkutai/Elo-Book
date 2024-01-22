//
//  DiscoverPostsView.swift
//  Elo Book
//
//  Created by Jed Kutai on 1/21/24.
//

import SwiftUI

private enum DiscoverTimeRestraint {
    case twelveHours
    case oneDay
    case oneWeek
}

struct DiscoverPostsView: View {
    @Binding var user: User
    
    @State private var timeRestraint: DiscoverTimeRestraint = .twelveHours
    @State private var discoverPosts: [Post] = []
    @Environment(\.colorScheme) var colorScheme
    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    Text("DISCOVER")
                        .foregroundStyle(colorScheme == .dark ? Theme.textColorDarkMode : Theme.textColor)
                        .fontWeight(.bold)
                    
                    Spacer()
                    
                    Menu {
                        Button {
                            timeRestraint = .twelveHours
                            localRefresh()
                        } label: {
                            Label("Last 12 hrs", systemImage: timeRestraint == .twelveHours ? "circle.fill" : "circle")
                        }
                        
                        Button {
                            timeRestraint = .oneDay
                            localRefresh()
                        } label: {
                            Label("Last 24 hrs", systemImage: timeRestraint == .oneDay ? "circle.fill" : "circle")
                        }
                        
                        Button {
                            timeRestraint = .oneWeek
                            localRefresh()
                        } label: {
                            Label("Last 7 days", systemImage: timeRestraint == .oneWeek ? "circle.fill" : "circle")
                        }
                        
                        
                        
                    } label: {
                        HStack {
                            switch timeRestraint {
                            case .twelveHours:
                                Text("Last 12 hrs")
                                    .foregroundStyle(colorScheme == .dark ? Theme.textColorDarkMode : Theme.textColor)
                            case .oneDay:
                                Text("Last 24 hrs")
                                    .foregroundStyle(colorScheme == .dark ? Theme.textColorDarkMode : Theme.textColor)
                            case .oneWeek:
                                Text("Last 7 days")
                                    .foregroundStyle(colorScheme == .dark ? Theme.textColorDarkMode : Theme.textColor)
                            }
                            Image(systemName: "clock.arrow.circlepath")
                                .foregroundColor(colorScheme == .dark ? Theme.buttonColorDarkMode : Theme.buttonColor)
                        }
                    }
                    
                }
                .padding(.horizontal)
                
                ScrollView(.vertical, showsIndicators: false) {
                    ForEach($discoverPosts, id: \.id) { post in
                        PostCell(user: $user, post: post)
                    }
                    
                    if discoverPosts.count >= 20 {
                        Button {
                            Task {
                                switch timeRestraint {
                                case .twelveHours:
                                    let newDiscoverPosts = try await FetchService.fetchMoreDiscoverPosts(user: user, timeRestraintHours: 12, otherPosts: discoverPosts)
                                    discoverPosts += newDiscoverPosts
                                case .oneDay:
                                    let newDiscoverPosts = try await FetchService.fetchMoreDiscoverPosts(user: user, timeRestraintHours: 24, otherPosts: discoverPosts)
                                    discoverPosts += newDiscoverPosts
                                case .oneWeek:
                                    let newDiscoverPosts = try await FetchService.fetchMoreDiscoverPosts(user: user, timeRestraintHours: 24*7, otherPosts: discoverPosts)
                                    discoverPosts += newDiscoverPosts
                                }
                                
                            }
                        } label: {
                            Text("show more")
                                .foregroundStyle(Color(.systemGray))
                                .font(.footnote)
                        }
                    }
                }
                .refreshable {
                    localRefresh()
                }
            }
            .onAppear {
                if discoverPosts.isEmpty {
                    Task {
                        discoverPosts = try await FetchService.fetchDiscoverPosts(user: user, timeRestraintHours: 12)
                    }
                }
            }
        }
    }
    
    private func localRefresh() {
        Task {
            switch timeRestraint {
            case .twelveHours:
                discoverPosts = try await FetchService.fetchDiscoverPosts(user: user, timeRestraintHours: 12)
            case .oneDay:
                discoverPosts = try await FetchService.fetchDiscoverPosts(user: user, timeRestraintHours: 24)
            case .oneWeek:
                discoverPosts = try await FetchService.fetchDiscoverPosts(user: user, timeRestraintHours: 24*7)
            }
            
        }
    }
}

