//
//  EventView.swift
//  EloBookv1
//
//  Created by Jed Kutai on 12/24/23.
//

import SwiftUI

struct EventView: View {
    @State var user: User
    @State var event: Event
    @State private var posts: [Post] = []
    @State private var loadingMorePosts = false
    @State private var sortByScore = true
    @State private var showCreatePostView = false
    @State private var postCreated = false
    @State private var swipeStarted = false
    
    
    
    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) var colorScheme
    @Namespace var namespace
    var body: some View {
        NavigationStack {
            ZStack {
                VStack {
                    
                    ScrollView(.vertical, showsIndicators: false) {
                        HStack {
                            Text("Start: \(DateFormatter.longDate(timestamp: event.timestamp))")
                                .font(.subheadline)
                                .foregroundStyle(Color(.systemGray))
                            NavigationLink {
                                EventChatRoomView(user: user, event: event)
                            } label: {
                                Text("Join Game Chat")
                                    .font(.subheadline)
                                    .foregroundStyle(Color(.systemBlue))
                            }
                        }
                        .padding(.horizontal)
                        
                        LazyVStack {
                            ForEach($posts, id: \.id) { post in
                                PostCell(user: $user, post: post)
                                    .padding(.top, 1)
                            }
                            
                            if posts.count >= 20 {
                                Button {
                                    Task {
                                        if sortByScore {
                                            posts = try await FetchService.fetchMoreEventPostsByScore(event: event, limit: posts.count + 20)
                                        } else {
                                            let newPosts = try await FetchService.fetchMoreEventPostsByTime(event: event, lastPost: posts.last)
                                            posts += newPosts
                                        }
                                        
                                    }
                                } label: {
                                    HStack {
                                        Spacer()
                                        
                                        if loadingMorePosts {
                                            ProgressView()
                                        } else {
                                            Text("Load more")
                                                .font(.footnote)
                                                .foregroundStyle(Color(.gray).opacity(0.3))
                                        }
                                        
                                        Spacer()
                                    }
                                }
                            }
                        }
                    }
                    .refreshable {
                        posts = []
                        Task {
                            if sortByScore {
                                posts = try await FetchService.fetchEventPostsByScore(event: event)
                            } else {
                                posts = try await FetchService.fetchEventPostsByTime(event: event)
                            }
                        }
                    }
                }
                
                VStack {
                    Spacer()
                    
                    HStack {
                        Spacer()
                        
                        Button {
                            showCreatePostView.toggle()
                        } label: {
                            Circle()
                                .fill(colorScheme == .dark ? Theme.textColor : Theme.textColorDarkMode)
                                .frame(width: 40, height: 40)
                                .overlay(
                                    Image(systemName: "square.and.pencil.circle.fill")
                                        .resizable()
                                        .scaledToFit()
                                        .foregroundColor(Color(.systemBlue))
                                        .frame(width: 38, height: 38)
                                )
                            
                        }
                    }
                    .padding(10)
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    MiniEventCell(event: event)
                        .matchedGeometryEffect(id: "MiniEventCell", in: namespace)
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Menu {
                        Button {
                            sortByScore.toggle()
                        } label: {
                            if sortByScore {
                                Label("Show Most Recent", systemImage: "clock.arrow.circlepath")
                            } else {
                                Label("Show Most Popular", systemImage: "square.stack.3d.up")
                            }
                        }
                        
                    } label: {
                        Image(systemName: "arrow.up.arrow.down.circle")
                            .foregroundColor(colorScheme == .dark ? Theme.buttonColorDarkMode : Theme.buttonColor)
                    }
                }
            }
            
        }
        .fullScreenCover(isPresented: $showCreatePostView) {
            CreatePostMasterView(user: user, postCreated: $postCreated, selectedEvents: [event])
        }
        .onAppear {
            Task {
                posts = try await FetchService.fetchEventPostsByScore(event: event)
            }
        }
        .onChange(of: sortByScore) {
            posts = []
            Task {
                if sortByScore {
                    posts = try await FetchService.fetchEventPostsByScore(event: event)
                } else {
                    posts = try await FetchService.fetchEventPostsByTime(event: event)
                }
            }
        }
        .onChange(of: postCreated) {
            posts = []
            Task {
                if sortByScore {
                    posts = try await FetchService.fetchEventPostsByScore(event: event)
                } else {
                    posts = try await FetchService.fetchEventPostsByTime(event: event)
                }
            }
        }
    }
}

