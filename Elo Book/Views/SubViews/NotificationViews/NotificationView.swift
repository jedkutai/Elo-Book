//
//  NotificationView.swift
//  Elo Book
//
//  Created by Jed Kutai on 1/20/24.
//

import SwiftUI

private enum NotificationShown {
    case newFollowers
    case newComments
    case newReplies
}

struct NotificationView: View {
    @Binding var user: User
    
    @EnvironmentObject var x: X
    @State private var navigationTitle = "New Followers"
    @State private var notificationShown: NotificationShown = .newFollowers
    
    private let screenWidth = UIScreen.main.bounds.width
    private let screenHeight = UIScreen.main.bounds.height
    @Environment(\.colorScheme) var colorScheme
    var body: some View {
        NavigationStack {
            
            TabView(selection: $notificationShown) {
                VStack {
                    ScrollView(.vertical, showsIndicators: false) {
                        FollowNotificationsView(user: $user)
                    }
                    .refreshable {
                        Task {
                            x.recentFollows = try await FetchService.fetchRecentFollowsByUser(user: user)
                        }
                    }
                }
                .tag(NotificationShown.newFollowers)
                
                VStack {
                    ScrollView(.vertical, showsIndicators: false) {
                        PostNotificationsView(user: $user)
                    }
                    .refreshable {
                        // reload
                        Task {
                            x.recentComments = try await FetchService.fetchRecentCommentAlertsByUser(user: user)
                        }
                    }
                }
                .tag(NotificationShown.newComments)
                
                VStack {
                    ScrollView(.vertical, showsIndicators: false) {
                        CommentNotificationsView(user: $user)
                    }
                    .refreshable {
                        // reload
                        Task {
                            // refresh recent replies
                            x.recentReplies = try await FetchService.fetchRecentReplyAlertsByUser(user: user)
                        }
                    }
                    
                }
                .tag(NotificationShown.newReplies)
            }
            .tabViewStyle(.page)
            .indexViewStyle(.page(backgroundDisplayMode: .always))
            .navigationTitle(navigationTitle)
            .navigationBarTitleDisplayMode(.inline)
            .onChange(of: notificationShown) {
                switch notificationShown {
                case .newFollowers:
                    navigationTitle = "New Followers"
                case .newComments:
                    navigationTitle = "New Comments"
                case .newReplies:
                    navigationTitle = "New Replies"
                }
            }
        }
    }
}

