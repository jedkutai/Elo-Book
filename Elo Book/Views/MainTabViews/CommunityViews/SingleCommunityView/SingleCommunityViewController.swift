//
//  SingleCommunityViewController.swift
//  Elo Book
//
//  Created by Jed Kutai on 2/3/24.
//

import SwiftUI

private enum CommunityViewShown {
    case home
    case members
    case info
    case settings
    case invites
    
}

struct SingleCommunityViewController: View {
    @Binding var user: User
    @State var community: Community
    
    @State private var communityViewShown: CommunityViewShown = .home
    @Environment(\.colorScheme) var colorScheme
    var body: some View {
        NavigationStack {
            VStack {
                TabView(selection: $communityViewShown) {
                    Text("Home")
                        .tabItem {
                            VStack {
                                Image(systemName: "house")
                                Text("Home")
                            }
                        }
                        .tag(CommunityViewShown.home)
                    
                    Text("Members")
                        .tabItem {
                            VStack {
                                Image(systemName: "person.3.sequence")
                                Text("Members")
                            }
                        }
                        .tag(CommunityViewShown.members)
                    
                    if user.id == community.ownerId {
                        
                        Text("Invites")
                            .tabItem {
                                VStack {
                                    Image(systemName: "person.badge.plus")
                                    Text("Invites")
                                }
                            }
                            .tag(CommunityViewShown.invites)
                    }
                    
                    
                    Text("Info")
                        .tabItem {
                            VStack {
                                Image(systemName: "info.circle")
                                Text("Info")
                            }
                        }
                        .tag(CommunityViewShown.info)
                    
                    if user.id == community.ownerId {
                        Text("Settings")
                            .tabItem {
                                VStack {
                                    Image(systemName: "gear")
                                    Text("settings")
                                }
                            }
                            .tag(CommunityViewShown.settings)
                        
                    }
                    
                }
                .accentColor(colorScheme == .dark ? Theme.buttonColorDarkMode : Theme.buttonColor)
            }
            .navigationTitle(community.communityDisplayName)
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

