//
//  ReplyAlertCell.swift
//  Elo Book
//
//  Created by Jed Kutai on 1/24/24.
//

import SwiftUI

struct ReplyAlertCell: View {
    @State var user: User
    @State var replyAlert: ReplyOnCommentAlert // new follwerId
    
    @State private var reply: Reply?
    @State private var replyUser: User?
    
    @State private var failed = false
    @State private var yellow = false
    
    @Environment(\.colorScheme) var colorScheme
    var body: some View {
        if let reply = reply, let replyUser = replyUser {
            NavigationStack {
                NavigationLink {
                    ExpandedCommentCellFromReplyAlert(user: user, replyAlert: replyAlert, targetReply: reply)
                } label: {
                    VStack {
                        // header
                        HStack {
                            NavigationLink {
                                AltUserProfileView(user: user, viewedUser: replyUser)
                            } label: {
                                HStack {
                                    SquareProfilePicture(user: replyUser, size: .xSmall)
                                    
                                    
                                    if let username = replyUser.username {
                                        Text(username)
                                            .font(.footnote)
                                            .fontWeight(.semibold)
                                            .foregroundColor(Color(.systemGray))
                                    }
                                    
                                    if let badge = replyUser.displayedBadge {
                                        BadgeDisplayer(badge: badge)
                                    }
                                    
                                }
                            }
                            
                            Text("replied to your comment.")
                                .font(.footnote)
                                .foregroundStyle(colorScheme == .dark ? Theme.textColorDarkMode : Theme.textColor)
                            
                            Spacer()
                            
                            Text(DateFormatter.shortDate(timestamp: replyAlert.timestamp))
                                .font(.footnote)
                                .foregroundStyle(Color(.systemGray))
                            
                            Image(systemName: "circle.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(height: 10)
                                .foregroundStyle(Color(yellow ? .systemYellow : .clear))
                            
                        }
                        
                        if let caption = reply.caption {
                            HStack {
                                Text("\(caption)")
                                    .multilineTextAlignment(.leading)
                                    .foregroundColor(colorScheme == .dark ? Theme.textColorDarkMode : Theme.textColor)
                                    .lineLimit(1)
                                    .truncationMode(.tail)
                                
                                Spacer()
                            }
                            .padding(.horizontal, 30)
                        }
                        
                        Divider()
                    }
                    .padding(.horizontal)
                }
            }
            .onAppear {
                if let notificationSeen = replyAlert.notificationSeen {
                    if !notificationSeen {
                        yellow = true
                        Task {
                            // update notification
                            try await NotificationService.replyOnCommentAlertSeen(user: user, replyAlert: replyAlert)
                            failed.toggle()
                            failed.toggle()
                        }
                    }
                } else {
                    yellow = true
                    Task {
                        // update notification
                        try await NotificationService.replyOnCommentAlertSeen(user: user, replyAlert: replyAlert)
                        failed.toggle()
                        failed.toggle()
                    }
                }
            }
        } else if failed {
            // show nothing
        } else {
            Image(systemName: "circle")
                .foregroundStyle(Color(.clear))
                .onAppear {
                    Task {
                        do {
                            reply = try await FetchService.fetchReplyByRelpyAlert(replyAlert: replyAlert)
                            if reply == nil {
                                failed = true
                            } else {
                                replyUser = try await FetchService.fetchUserById(withUid: replyAlert.userId)
//                                failed = replyUser == nil
                                if replyUser == nil {
                                    failed = true
                                }
                            }
                        } catch {
                            failed = true
                        }
                    }
                }
        }
    }
}


