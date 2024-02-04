//
//  CommunityView.swift
//  Elo Book
//
//  Created by Jed Kutai on 1/25/24.
//

import SwiftUI

private enum SelectedTab {
    case communities
    case searchCommunites
}


struct CommunityView: View {
    @Binding var user: User
    
    @State private var communities: [Community] = []
    @State private var canCreateCommunity: Bool = false
    @State private var refreshCommunitiesView: Bool = false
    @State private var failed: Bool = false
    
    @State private var selectedTab: SelectedTab = .communities
    @Environment(\.colorScheme) var colorScheme
    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    Group {
                        switch selectedTab {
                        case .communities:
                            Text("Communities") // change this to searchbar
                        case .searchCommunites:
                            Text("Discover")
                        }
                    }
                    .foregroundStyle(colorScheme == .dark ? Theme.textColorDarkMode : Theme.textColor)
                    .fontWeight(.bold)
                        
                    
                    Spacer()
                    
                    if canCreateCommunity {
                        NavigationLink {
                            SelectCommunityNameView(user: $user, refreshCommunitiesView: $refreshCommunitiesView)
                        } label: {
                            Label("Create", systemImage: "plus.square")
                                .foregroundStyle(Color(.systemBlue))
                        }
                    }
                }
                .padding(.horizontal)
                
                TabView(selection: $selectedTab) {
                    YourCommunitiesView(user: $user, communities: $communities, refreshCommunitiesView: $refreshCommunitiesView)
                        .tag(SelectedTab.communities)
                    
                    Text("Find Communities")
                        .tag(SelectedTab.searchCommunites)
                    
                }
                .tabViewStyle(.page)
                .indexViewStyle(.page(backgroundDisplayMode: .always))
            }
            .onAppear {
                self.checkIfUserCanCreateCommunity()
                Task {
                    do {
                        communities = try await FetchService.fetchCommunitesByUser(user: user)
                    } catch {
                        failed = true
                    }
                }
            }
            .onChange(of: refreshCommunitiesView) {
                self.checkIfUserCanCreateCommunity()
            }
        }
    }
    
    private func checkIfUserCanCreateCommunity() {
        if let communitiesMade = user.communitiesMade {
            if communitiesMade == 0 {
                canCreateCommunity = true
            } else {
                canCreateCommunity = false
            }
        } else {
            canCreateCommunity = true
        }
    }
    
    
}

