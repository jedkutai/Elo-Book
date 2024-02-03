//
//  YourCommunitiesView.swift
//  Elo Book
//
//  Created by Jed Kutai on 2/3/24.
//

import SwiftUI

struct YourCommunitiesView: View {
    @Binding var user: User
    @Binding var communities: [Community]
    @Binding var refreshCommunitiesView: Bool
    
    @State private var failed: Bool = false
    @Environment(\.colorScheme) var colorScheme
    var body: some View {
        NavigationStack {
            VStack {
                if failed {
                    Text("An error occured.")
                    
                    Button {
                        failed = false
                        self.refreshCommunities()
                    } label: {
                        Label("Reload", systemImage: "arrow.circlepath")
                            .foregroundColor(Color(.systemBlue))
                    }
                    
                } else {
                    ScrollView(.vertical, showsIndicators: false) {
                        ForEach(communities, id: \.id) { community in
                            Text(community.communityName)
                        }
                    }
                }
            }
        }
        .onChange(of: refreshCommunitiesView) {
            self.refreshCommunities()
        }
    }
    
    private func refreshCommunities() {
        Task {
            do {
                user = try await FetchService.fetchUserById(withUid: user.id)
                
                
                let loadedCommunities = try await FetchService.fetchCommunitesByUser(user: user)
                communities = []
                communities = loadedCommunities
            } catch {
                failed = true
            }
        }
    }
}

