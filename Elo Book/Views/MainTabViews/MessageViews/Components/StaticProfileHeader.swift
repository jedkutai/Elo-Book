//
//  StaticProfileHeader.swift
//  Elo Book
//
//  Created by Jed Kutai on 1/11/24.
//

import SwiftUI

struct StaticProfileHeader: View {
    @State var viewedUser: User
    
    @State private var followingCount: Int?
    @State private var followersCount: Int?
    @State private var userProfilePostsCount: Int?
    
    @Environment(\.colorScheme) var colorScheme
    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    SquareProfilePicture(user: viewedUser, size: .large)
                    
                    VStack {
                        HStack {
                            if let fullname = viewedUser.fullname {
                                Text("\(fullname)")
                                    .fontWeight(.semibold)
                                    .foregroundStyle(colorScheme == .dark ? Theme.textColorDarkMode : Theme.textColor)
                            }
                            Spacer()
                        }

                        
                        HStack {
                            VStack {
                                
                                HStack{
                                    Text("Posts: \(userProfilePostsCount ?? 0)")
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
                    
                    
                    Spacer()
                }
                
                if let bio = viewedUser.bio {
                    HStack {
                        Text("\(bio)")
                            .font(.footnote)
                            .foregroundStyle(colorScheme == .dark ? Theme.textColorDarkMode : Theme.textColor)
                        Spacer()
                    }
                }
                
            }
            .frame(width: UIScreen.main.bounds.width * 0.5)
            .padding()
            .overlay(
                    RoundedRectangle(cornerRadius: 15) // Adjust the corner radius as needed
                        .stroke(Color(.systemGray), lineWidth: 2) // Adjust the color and width of the border
                )
            .onAppear {
                Task {
                    followersCount = try await FetchService.fetchFollowersCount(userId: viewedUser.id)
                    followingCount = try await FetchService.fetchFollowingCount(userId: viewedUser.id)
                    userProfilePostsCount = try await FetchService.fetchPostCount(userId: viewedUser.id)
                }
            }
        }
    }
}
