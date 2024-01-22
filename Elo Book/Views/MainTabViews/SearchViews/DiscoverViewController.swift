//
//  DiscoverViewController.swift
//  Elo Book
//
//  Created by Jed Kutai on 1/21/24.
//

import SwiftUI

struct DiscoverViewController: View {
    @Binding var user: User
    
    var body: some View {
        NavigationStack {
            TabView {
                SearchView2(user: $user)
                
                DiscoverPostsView(user: $user)
            }
            .tabViewStyle(.page)
            .indexViewStyle(.page(backgroundDisplayMode: .always))
        }
    }
}

