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
    
    var body: some View {
        NavigationStack {
            ZStack {
                VStack {
                    HStack {
                        Button {
                            dismiss()
                        } label: {
                            Image(systemName: "chevron.left")
                                .foregroundColor(colorScheme == .dark ? Theme.buttonColorDarkMode : Theme.buttonColor)
                        }
                        
                        Spacer()
                        
                        EventCell(event: event)
                        
                        Spacer()
                        
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
                            Image(systemName: "arrow.up.arrow.down.circle.fill")
                                .foregroundColor(colorScheme == .dark ? Theme.buttonColorDarkMode : Theme.buttonColor)
                        }
                    }
                    .padding(.horizontal)
                    
                    
                    
                    NavigationLink {
                        EventChatRoomView(user: user, event: event).navigationBarBackButtonHidden()
                    } label: {
                        Text("Join Game Chat")
                            .foregroundStyle(Color(.systemBlue))
                    }
                
                    Divider()
                        .frame(height: 1)
                    
                    ScrollView(.vertical, showsIndicators: false) {
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
            
        }
        .gesture(
            DragGesture()
                .onChanged { value in
                    if value.startLocation.y < 40 {
                        self.swipeStarted = true
                    }
                }
                .onEnded { _ in
                    self.swipeStarted = false
                    dismiss()
                }
        )
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

