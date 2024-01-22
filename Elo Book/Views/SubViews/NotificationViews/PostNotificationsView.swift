//
//  PostNotificationsView.swift
//  Elo Book
//
//  Created by Jed Kutai on 1/20/24.
//

import SwiftUI

struct PostNotificationsView: View {
    @Binding var user: User
    
    @EnvironmentObject var x: X
    var body: some View {
        NavigationStack {
            LazyVStack {
                
                ForEach(x.recentComments, id: \.id) { commentAlert in
                    CommentAlertCell(user: user, commentAlert: commentAlert)
                }
                
                
            }
            .padding(.vertical, 5)
            .onAppear {
                x.unseenComments = false
                x.setUnseenNotifications()
            }
        }
    }
}

