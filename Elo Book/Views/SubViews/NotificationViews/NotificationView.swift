//
//  NotificationView.swift
//  Elo Book
//
//  Created by Jed Kutai on 1/20/24.
//

import SwiftUI

struct NotificationView: View {
    @Binding var user: User
    
    
    @EnvironmentObject var x: X
    private let screenWidth = UIScreen.main.bounds.width
    private let screenHeight = UIScreen.main.bounds.height
    @Environment(\.colorScheme) var colorScheme
    var body: some View {
        NavigationStack {
            VStack {
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack {
                        ScrollView(.vertical, showsIndicators: false) {
                            FollowNotificationsView(user: $user)
                        }
                        .refreshable {
                            Task {
                                x.recentFollows = try await FetchService.fetchRecentFollowsByUser(user: user)
                            }
                        }
                        .frame(width: screenWidth)
                        .id(0)
                        
                        
                        ScrollView(.vertical, showsIndicators: false) {
                            PostNotificationsView(user: $user)
                        }
                        .frame(width: screenWidth)
                        .id(1)
                    }
                    .scrollTargetLayout()
                }
                .scrollTargetBehavior(.viewAligned)
                
                Spacer()
            }
            .navigationTitle("Notifications")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

