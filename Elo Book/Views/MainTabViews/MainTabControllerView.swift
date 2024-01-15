//
//  MainTabControllerView.swift
//  EloBookv1
//
//  Created by Jed Kutai on 12/23/23.
//

import SwiftUI

enum Tab {
    case home
    case search
    case profile
    case messages
    case communities
}

struct MainTabControllerView: View {
    @State var user: User
    
    @State var selectedTab: Tab = .home
    @State private var refresh = false
    
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
                
                
                MessageView(user: $user)
                    .accentColor(colorScheme == .dark ? Theme.textColorDarkMode : Theme.textColor)
                    .tabItem {
                        VStack {
                            Image(systemName: "pencil.and.scribble")
                            Text("Messages")
                        }
                    }
                    .tag(Tab.messages)
                

                SearchView2(user: $user)
                    .tabItem {
                        VStack {
                            Image(systemName: "magnifyingglass")
                            Text("Search")
                        }
                    }
                    .tag(Tab.search)
                
                
                Text("Under Construction").foregroundStyle(colorScheme == .dark ? Theme.textColorDarkMode : Theme.textColor)
                    .accentColor(colorScheme == .dark ? Theme.textColorDarkMode : Theme.textColor)
                    .tabItem {
                        VStack {
                            Image(systemName: "rectangle.3.group.fill")
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
        .onChange(of: refresh) {
            Task {
                user = try await FetchService.fetchUserById(withUid: user.id)
            }
        }
    }
}

#Preview {
    MainTabControllerView(user: User.MOCK_USER)
}
