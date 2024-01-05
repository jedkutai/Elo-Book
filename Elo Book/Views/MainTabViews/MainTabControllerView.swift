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
}

struct MainTabControllerView: View {
    @State var user: User
//    @State private var tabSelection = 1
    @State private var refresh = false
    @Environment(\.colorScheme) var colorScheme
    var body: some View {
        NavigationStack {
            TabView {
                UserFeedView(user: $user)
                    .tabItem {
                        VStack {
                            Image(systemName: "house")
                            Text("Home")
                        }
                    }
                    .tag(Tab.home)
                

                SearchView(user: $user)
                    .tabItem {
                        VStack {
                            Image(systemName: "magnifyingglass")
                            Text("Search")
                        }
                    }
                    .tag(Tab.search)
                
                
                UserProfileView(user: $user, refresh: $refresh)
                    .tabItem {
                        VStack {
                            Image(systemName: "person.fill")
                            Text("Me")
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
