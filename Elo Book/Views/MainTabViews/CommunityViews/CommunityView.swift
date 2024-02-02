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
    
    
    @State private var canCreateCommunity: Bool = false
    
    @State private var selectedTab: SelectedTab = .communities
    @Environment(\.colorScheme) var colorScheme
    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    Group {
                        switch selectedTab {
                        case .communities:
                            Text("Communities")
                        case .searchCommunites:
                            Text("Discover")
                        }
                    }
                    .foregroundStyle(colorScheme == .dark ? Theme.textColorDarkMode : Theme.textColor)
                    .fontWeight(.bold)
                        
                    
                    Spacer()
                    
                    if canCreateCommunity {
                        NavigationLink {
                            // create community
                        } label: {
                            Label("Create", systemImage: "plus.square")
                                .foregroundStyle(Color(.systemBlue))
                        }
                    }
                }
                .padding(.horizontal)
                
                TabView(selection: $selectedTab) {
                    Text("Your Communities")
                        .tag(SelectedTab.communities)
                    
                    Text("Find Communities")
                        .tag(SelectedTab.searchCommunites)
                    
                }
                .tabViewStyle(.page)
                .indexViewStyle(.page(backgroundDisplayMode: .always))
            }
            .onAppear {
                if let communities = user.communities {
                    if communities == 0 {
                        canCreateCommunity = true
                    }
                } else {
                    canCreateCommunity = true
                }
            }
        }
    }
}

