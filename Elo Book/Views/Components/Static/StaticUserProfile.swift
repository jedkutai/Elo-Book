//
//  StaticUserProfile.swift
//  Elo Book
//
//  Created by Jed Kutai on 1/16/24.
//

import SwiftUI

struct StaticUserProfile: View {
    @State var user: User
    @State var userToShare: User
    
    @State private var followingCount: Int?
    @State private var followersCount: Int?
    @State private var postCount: Int?
    
    
    @Environment(\.colorScheme) var colorScheme
    var body: some View {
        VStack {
            HStack {
               
                if let username = userToShare.username {
                    Text("\(username)")
                        .foregroundColor(colorScheme == .dark ? Theme.textColorDarkMode : Theme.textColor)
                        .fontWeight(.bold)
                }
                
                if let badge = userToShare.displayedBadge {
                    BadgeDisplayer(badge: badge)
                }
                
                
            }
            .padding(.horizontal)
            
            VStack {
                HStack {
                    SquareProfilePicture(user: userToShare, size: .large)
                    
                    VStack {
                        HStack {
                            if let fullname = userToShare.fullname {
                                Text("\(fullname)")
                                    .fontWeight(.semibold)
                                    .foregroundStyle(colorScheme == .dark ? Theme.textColorDarkMode : Theme.textColor)
                                Spacer()
                            }
                        }

                        
                        HStack {
                            VStack {
                                
                                HStack{
                                    Text("Posts: \(postCount ?? 0)")
                                        .font(.footnote)
                                        .foregroundStyle(colorScheme == .dark ? Theme.textColorDarkMode : Theme.textColor)
                                    
                                    Spacer()
                                }
                                
                                
                                HStack {
                                    Text("Following: \(followingCount ?? 0)")
                                        .font(.footnote)
                                        .foregroundStyle(colorScheme == .dark ? Theme.textColorDarkMode : Theme.textColor)
                                    
                                    Spacer()
                                }
                                
                                HStack {
                                    Text("Followers: \(followersCount ?? 0)")
                                        .font(.footnote)
                                        .foregroundStyle(colorScheme == .dark ? Theme.textColorDarkMode : Theme.textColor)
                                    
                                    Spacer()
                                }

                            }
                            
                            
                            Spacer()
                        }
                            
                    }
                    .padding(.horizontal, 4)
                    
                    
                    Spacer()
                }
                
                if let bio = userToShare.bio {
                    HStack {
                        Text("\(bio)")
                            .font(.subheadline)
                            .foregroundStyle(colorScheme == .dark ? Theme.textColorDarkMode : Theme.textColor)
                        Spacer()
                    }
                }
                
            }
        }
        .padding(.horizontal, 10)
        .padding(10)
        .frame(maxWidth: UIScreen.main.bounds.width * 0.7)
        .background(
            RoundedRectangle(cornerRadius: 15)
                .foregroundStyle(Color(.gray).opacity(0.15))
        )
        .onAppear {
            Task {
                followersCount = try await FetchService.fetchFollowersCount(userId: userToShare.id)
                followingCount = try await FetchService.fetchFollowingCount(userId: userToShare.id)
                postCount = try await FetchService.fetchPostCount(userId: userToShare.id)
            }
        }
    }
}
