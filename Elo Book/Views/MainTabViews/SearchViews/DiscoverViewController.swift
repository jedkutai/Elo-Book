//
//  DiscoverViewController.swift
//  Elo Book
//
//  Created by Jed Kutai on 1/21/24.
//

import SwiftUI

struct DiscoverViewController: View {
    @Binding var user: User
    
    @State private var selectedTab = 1
    @Environment(\.colorScheme) private var colorScheme
    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    Text(selectedTab == 1 ? "Search" : "Discover")
                        .foregroundStyle(colorScheme == .dark ? Theme.textColorDarkMode : Theme.textColor)
                        .fontWeight(.bold)
                    
                    Spacer()
                    
                }
                .padding(.horizontal)
                
                TabView(selection: $selectedTab) {
                    SearchView2(user: $user)
                        .tag(1)
                    
                    DiscoverPostsView(user: $user)
                        .tag(2)
                }
                .tabViewStyle(.page)
                .indexViewStyle(.page(backgroundDisplayMode: .always))
            }
        }
    }
}

