//
//  MainTabControllerView.swift
//  EloBookv1
//
//  Created by Jed Kutai on 12/23/23.
//

import SwiftUI

enum Tab {
    case home
    case discover
    case profile
    case messages
    case communities
}

struct MainTabControllerView: View {
    @State var user: User
    
    @State private var threads: [Thread] = []
    @State private var unreadMessageCount = 0
    
    @State var selectedTab: Tab = .home
    @State private var refresh = false
    @State private var showTermsOfService = false
    @EnvironmentObject var x: X
    @Environment(\.colorScheme) var colorScheme
    var body: some View {
        NavigationStack {
            TabView(selection: $x.selectedTab) {
                UserFeedView(user: $user)
                    .tabItem {
                        VStack {
                            Image(systemName: "house")
                            Text("Home")
                        }
                    }
                    .tag(Tab.home)
                
                
                MessageView(user: $user, threads: $threads, unreadMessageCount: $unreadMessageCount)
                    .accentColor(colorScheme == .dark ? Theme.textColorDarkMode : Theme.textColor)
                    .tabItem {
                        VStack {
                            Image(systemName: unreadMessageCount > 0 ? "exclamationmark.bubble.fill" : "bubble.fill")
                            if unreadMessageCount == 0 {
                                Text("Messages")
                            } else if unreadMessageCount == 1 {
                                Text("\(unreadMessageCount) Message")
                            } else if unreadMessageCount < 10 {
                                Text("\(unreadMessageCount) Messages")
                            } else {
                                Text("10+ Messages")
                            }
                        }
                    }
                    .tag(Tab.messages)
                

                
                DiscoverViewController(user: $user)
                    .tabItem {
                        VStack {
                            Image(systemName: "magnifyingglass")
                            Text("Discover")
                        }
                    }
                    .tag(Tab.discover)
                
                CommunityView(user: $user)
                    .tabItem {
                        VStack {
                            Image(systemName: "rectangle.3.group")
                            Text("Communities")
                        }
                    }
                    .tag(Tab.communities)
                
                UserProfileView(user: $user, refresh: $refresh)
                    .tabItem {
                        VStack {
                            Image(systemName: "person.fill")
                            Text("Profile")
                        }
                    }
                    .tag(Tab.profile)
            }
            .accentColor(colorScheme == .dark ? Theme.buttonColorDarkMode : Theme.buttonColor)
        }
        .fullScreenCover(isPresented: $showTermsOfService) {
            TermsOfServiceView(user: $user)
        }
        .onAppear {
            if let terms = user.termsOfServiceV1 {
                if !terms {
                    showTermsOfService.toggle()
                }
            } else {
                showTermsOfService.toggle()
            }
            Task {
                threads = try await FetchService.fetchMessageThreadsByUser(user: user)
                unreadMessageCount = try await MessageService.unreadMessagesCount(user: user, threads: threads)
            }
        }
        .onChange(of: refresh) {
            Task {
                user = try await FetchService.fetchUserById(withUid: user.id)
                threads = try await FetchService.fetchMessageThreadsByUser(user: user)
                unreadMessageCount = try await MessageService.unreadMessagesCount(user: user, threads: threads)
            }
        }
    }
}

#Preview {
    MainTabControllerView(user: User.MOCK_USER)
}
