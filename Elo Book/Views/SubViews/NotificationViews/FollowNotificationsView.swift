//
//  FollowNotificationsView.swift
//  Elo Book
//
//  Created by Jed Kutai on 1/20/24.
//

import SwiftUI

struct FollowNotificationsView: View {
    @Binding var user: User
    
    @EnvironmentObject var x: X
    var body: some View {
        NavigationStack {
            LazyVStack {
                
                ForEach(x.recentFollows, id: \.id) { follow in
                    FollowNotificationCell(user: user, follow: follow)
                }
                
                Text("Swipe ->")
                    .foregroundStyle(Color(.systemGray))
                    .font(.footnote)
            }
            .padding(.vertical, 5)

            
        }
        .onAppear {
            x.unseenFollows = false
            x.setUnseenNotifications()
            
        }
    }
}
