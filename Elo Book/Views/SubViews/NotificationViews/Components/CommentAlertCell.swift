//
//  CommentAlertCell.swift
//  Elo Book
//
//  Created by Jed Kutai on 1/20/24.
//

import SwiftUI

struct CommentAlertCell: View {
    @State var user: User
    @State var commentAlert: CommentOnPostAlert // new follwerId
    
    @State private var comment: Comment?
    @State private var commentUser: User?
    
    @State private var failed = false
    @State private var yellow = false
    
    @Environment(\.colorScheme) var colorScheme
    var body: some View {
        if let comment = comment, let commentUser = commentUser {
            NavigationStack {
                NavigationLink {
                    ExpandedPostCellFromCommentAlert(user: user, commentAlert: commentAlert, targetComment: comment)
                } label: {
                    VStack {
                        // header
                        HStack {
                            NavigationLink {
                                AltUserProfileView(user: user, viewedUser: commentUser)
                            } label: {
                                HStack {
                                    SquareProfilePicture(user: commentUser, size: .xSmall)
                                    
                                    if let username = commentUser.username {
                                        Text(username)
                                            .font(.footnote)
                                            .fontWeight(.semibold)
                                            .foregroundColor(Color(.systemGray))
                                    }
                                    
                                    if let badge = commentUser.displayedBadge {
                                        BadgeDisplayer(badge: badge)
                                    }
                                    
                                }
                            }
                            
                            Text("commented on your post.")
                                .font(.footnote)
                                .foregroundStyle(colorScheme == .dark ? Theme.textColorDarkMode : Theme.textColor)
                            
                            Spacer()
                            
                            Text(DateFormatter.shortDate(timestamp: commentAlert.timestamp))
                                .font(.footnote)
                                .foregroundStyle(Color(.systemGray))
                            
                            Image(systemName: "circle.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(height: 10)
                                .foregroundStyle(Color(yellow ? .systemYellow : .clear))
                            
                        }
                        
                        if let caption = comment.caption {
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
                if let notificationSeen = commentAlert.notificationSeen {
                    if !notificationSeen {
                        yellow = true
                        Task {
                            // update notification
                            try await NotificationService.commentOnPostAlertSeen(user: user, commentAlert: commentAlert)
                            failed.toggle()
                            failed.toggle()
                        }
                    }
                } else {
                    yellow = true
                    Task {
                        // update notification
                        try await NotificationService.commentOnPostAlertSeen(user: user, commentAlert: commentAlert)
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
                            comment = try await FetchService.fetchCommentByCommentAlert(commentAlert: commentAlert)
                            if comment == nil {
                                failed = true
                            } else {
                                commentUser = try await FetchService.fetchUserById(withUid: commentAlert.userId)
                                if commentUser == nil {
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

