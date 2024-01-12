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
}

struct MainTabControllerView: View {
    @State var user: User
    
    @State var selectedTab: Tab = .home
    @State private var refresh = false
    
    @EnvironmentObject var x: X
    @Environment(\.colorScheme) var colorScheme
    var body: some View {
        NavigationStack {
            TabView(selection: $selectedTab) {
                UserFeedView(user: $user)
                    .tabItem {
                        VStack {
                            Image(systemName: "house")
                            Text("Home")
                        }
                    }
                    .tag(Tab.home)
                

                SearchView2(user: $user)
                    .tabItem {
                        VStack {
                            Image(systemName: "magnifyingglass")
                            Text("Search")
                        }
                    }
                    .tag(Tab.search)
                
                MessageView(user: $user)
                    .accentColor(colorScheme == .dark ? Theme.textColorDarkMode : Theme.textColor)
                    .tabItem {
                        VStack {
                            Image(systemName: "pencil.and.scribble")
                            Text("Messages")
                        }
                    }
                    .tag(Tab.messages)
                
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
