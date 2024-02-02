//
//  ReplyCell.swift
//  Elo Book
//
//  Created by Jed Kutai on 1/22/24.
//

import SwiftUI

struct ReplyCell: View {
    @Binding var user: User
    @State var reply: Reply
    
    @State private var replyUser: User?
    
    @EnvironmentObject var x: X
    @State private var hidden = false
    
    @State private var likes: [ReplyLike] = []
    @State private var likeCooldown = false
    @State private var showMore = false
    @State private var replyDeleted = false
    @State private var showMoreText = false
    @State private var failed = false
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        if replyDeleted || self.failed {
            
        } else {
            replyCell
        }
    }
    
    var replyCell: some View {
        NavigationStack {
            if let replyUser = replyUser {
                VStack {
                    HStack {
                        
                        VStack {
                            HStack {
                                NavigationLink {
                                    AltUserProfileView(user: user, viewedUser: replyUser)
                                } label: {
                                    HStack {
                                        SquareProfilePicture(user: replyUser, size: .xSmall)
                                        
                                        if let fullname = replyUser.fullname {
                                            Text(fullname)
                                                .font(.footnote)
                                                .fontWeight(.semibold)
                                                .foregroundStyle(colorScheme == .dark ? Theme.textColorDarkMode : Theme.textColor)
                                        }
                                        
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
                                
                                

                                
                                if showMore {
                                    if user.id == replyUser.id {
                                        Button {
                                            Task {
                                                try await ReplyService.deleteReply(reply: reply)
                                            }
                                            replyDeleted.toggle()
                                        } label: {
                                            Label("Delete", systemImage: "trash")
                                                .font(.subheadline)
                                                .foregroundStyle(Color(.red))
                                        }
                                    } else {
                                        NavigationLink {
                                            ReportReplyView(user: user, replyUser: replyUser, reply: reply)
                                        } label: {
                                            Label("Report", systemImage: "exclamationmark.triangle.fill")
                                                .font(.footnote)
                                                .foregroundStyle(Color(.orange))
                                        }
                                    }
                                    
                                } else {
                                    Button {
                                        showMore.toggle()
                                    } label: {
                                        Image(systemName: "ellipsis")
                                            .foregroundStyle(colorScheme == .dark ? Theme.buttonColorDarkMode : Theme.buttonColor)
                                    }
                                }
                                
                                
                                Spacer()
                            }
                            
                            if let caption = reply.caption {
                                if showMoreText {
                                    Text(caption)
                                        .font(.subheadline)
                                        .foregroundStyle(colorScheme == .dark ? Theme.textColorDarkMode : Theme.textColor)
                                        .multilineTextAlignment(.leading)
                                    
                                } else {
                                    if caption.count <= 100 {
                                        HStack {
                                            Text(caption)
                                                .font(.subheadline)
                                                .foregroundStyle(colorScheme == .dark ? Theme.textColorDarkMode : Theme.textColor)
                                                .multilineTextAlignment(.leading)
                                            
                                            Spacer()
                                        }
                                    } else {
                                        
                                        Button {
                                            showMoreText.toggle()
                                        } label: {
                                            Group {
                                                Text("\(String(caption.prefix(75)))")
                                                    .font(.subheadline)
                                                    .foregroundStyle(colorScheme == .dark ? Theme.textColorDarkMode : Theme.textColor)
                                                
                                                + Text("...Show more.")
                                                    .font(.subheadline)
                                                    .foregroundStyle(Color(.systemBlue))
                                            }
                                            .multilineTextAlignment(.leading)
                                        }
                                    }
                                }
                            }
                        }
                        
                        VStack {
                            Text(DateFormatter.shortDate(timestamp: reply.timestamp))
                                .font(.subheadline)
                                .foregroundColor(.gray)
                            Button {
                                if !likeCooldown {
                                    likeCooldown = true
                                    Task {
                                        if likes.contains(where: { $0.userId == user.id }) {
                                            try await ReplyService.unlikeReply(reply: reply, user: user)
                                            
                                        } else {
                                            try await ReplyService.likeReply(reply: reply, user: user)
                                        }
                                        likes = try await FetchService.fetchReplyLikesByReplyId(reply: reply)
                                        likeCooldown = false
                                    }
                                    
                                }
                            } label: {
                                HStack {
                                    if likes.contains(where: { $0.userId == user.id }) {
                                        Image(systemName: "square.stack.3d.up.fill")
                                            .foregroundColor(Theme.buttonColorInteracted)
                                    } else {
                                        Image(systemName: "square.stack.3d.up")
                                            .foregroundColor(colorScheme == .dark ? Theme.buttonColorDarkMode : Theme.buttonColor)
                                    }
                                    
                                    Text("\(likes.count)")
                                        .font(.subheadline)
                                        .foregroundStyle(colorScheme == .dark ? Theme.textColorDarkMode : Theme.textColor)
                                    
                                }
                                
                                    
                            }
                        }
                        
                    }
                    
                    
                    
//                    Divider()
                }
                .padding(.horizontal)
                
            } else if failed {
                
            }
        }
        .onChange(of: showMore) {
            if showMore {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    showMore = false
                }
            }
        }
        .onAppear {
            let blockedByUser = x.blockedBy.contains { block in
                return block.userId == reply.userId
            }
            
            let blockedUser = x.blocked.contains { block in
                return block.userToBlockId == reply.userId
            }
            
            self.hidden = blockedByUser || blockedUser
            
            Task {
                do {
                    replyUser = try await FetchService.fetchUserById(withUid: reply.userId)
                    likes = try await FetchService.fetchReplyLikesByReplyId(reply: reply)
                } catch {
                    failed = true
                }
            }
        }
    }
}


