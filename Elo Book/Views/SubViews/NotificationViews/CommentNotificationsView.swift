//
//  CommentNotificationsView.swift
//  Elo Book
//
//  Created by Jed Kutai on 1/24/24.
//

import SwiftUI

struct CommentNotificationsView: View {
    @Binding var user: User
    
    @EnvironmentObject var x: X
    
    var body: some View {
        NavigationStack {
            LazyVStack {
                
                ForEach(x.recentReplies, id: \.id) { replyAlert in
                    // reply alert cell
                    ReplyAlertCell(user: user, replyAlert: replyAlert)
                }
                
                
            }
            .padding(.vertical, 5)
            .onAppear {
                 x.unseenReplies = false
                x.setUnseenNotifications()
            }
        }
    }
}

