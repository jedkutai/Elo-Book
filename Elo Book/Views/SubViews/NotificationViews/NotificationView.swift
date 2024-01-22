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
            
            TabView {
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
            }
            .tabViewStyle(.page)
            .indexViewStyle(.page(backgroundDisplayMode: .always))
            .navigationTitle("Notifications")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

