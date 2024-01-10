//
//  NotificationsSettingsView.swift
//  Elo Book
//
//  Created by Jed Kutai on 1/8/24.
//

import SwiftUI

struct NotificationsSettingsView: View {
    @State var user: User
    @Binding var refresh: Bool
    
    @State private var notificationSettings: UserNotificationSettings?
    
    @State private var followAlerts: Bool = true
    @State private var likedPostAlerts: Bool = true
    @State private var commentedPostAlerts: Bool = true
    @State private var likedCommentAlerts: Bool = true
    @State private var communityInviteAlerts: Bool = true
    @State private var communityMessageAlerts: Bool = true
    
    
    @State private var swipeStarted = false
    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) var colorScheme
    var body: some View {
        NavigationStack {
            VStack {
                // header
                HStack {
                    Button {
                        dismiss()
                        Task {
                            await UserService.updateUserNotificationSettings(user: user, followAlerts: followAlerts, likedPostAlerts: likedPostAlerts, commentedPostAlerts: commentedPostAlerts, likedCommentAlerts: likedCommentAlerts, communityInviteAlerts: communityInviteAlerts, communityMessageAlerts: communityMessageAlerts)
                            
                            refresh.toggle()
                        }
                        
                    } label: {
                        Image(systemName: "chevron.left")
                            .foregroundStyle(colorScheme == .dark ? Theme.buttonColorDarkMode : Theme.buttonColor)
                        
                    }
                    
                    Spacer()
                    
                    Text("Notifications")
                        .font(.headline)
                        .foregroundStyle(colorScheme == .dark ? Theme.textColorDarkMode : Theme.textColor)
                    
                    Spacer()
                    
                    Image(systemName: "chevron.left")
                        .foregroundStyle(Color.clear)
                    
                }
                .padding(.horizontal)
                
                Divider()
                    .frame(height: 1)
                

                if notificationSettings != nil {
                    ScrollView {
                        HStack {
                            Text("General Alerts")
                                .foregroundStyle(colorScheme == .dark ? Theme.textColorDarkMode : Theme.textColor)
                                .fontWeight(.semibold)
                            
                            Spacer()
                        }
                        
                        HStack {
                            
                            Button {
                                followAlerts.toggle()
                            } label: {
                                Text("New Follower")
                                    .foregroundStyle(Color(.systemGray))
                                
                                Spacer()
                                
                                if followAlerts {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundStyle(Color(.green))
                                } else {
                                    
                                    Image(systemName: "circle")
                                        .foregroundStyle(colorScheme == .dark ? Theme.buttonColorDarkMode : Theme.buttonColor)
                                }
                            }
                        }
                        .padding(.leading)
                        
                        HStack {
                            Text("Post Alerts")
                                .foregroundStyle(colorScheme == .dark ? Theme.textColorDarkMode : Theme.textColor)
                                .fontWeight(.semibold)
                            
                            Spacer()
                        }
                        
                        HStack {
                            
                            
                            Button {
                                commentedPostAlerts.toggle()
                            } label: {
                                Text("New Comment")
                                    .foregroundStyle(Color(.systemGray))
                                
                                Spacer()
                                
                                if commentedPostAlerts {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundStyle(Color(.green))
                                } else {
                                    Image(systemName: "circle")
                                        .foregroundStyle(colorScheme == .dark ? Theme.buttonColorDarkMode : Theme.buttonColor)
                                }
                            }
                        }
                        .padding(.leading)
                        
                        HStack {
                            
                            Button {
                                likedPostAlerts.toggle()
                            } label: {
                                Text("New Like")
                                    .foregroundStyle(Color(.systemGray))
                                
                                Spacer()
                                
                                if likedPostAlerts {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundStyle(Color(.green))
                                } else {
                                    Image(systemName: "circle")
                                        .foregroundStyle(colorScheme == .dark ? Theme.buttonColorDarkMode : Theme.buttonColor)
                                }
                            }
                        }
                        .padding(.leading)
                        
                        
                        
                        
                        
                        HStack {
                            Text("Comment Alerts")
                                .foregroundStyle(colorScheme == .dark ? Theme.textColorDarkMode : Theme.textColor)
                                .fontWeight(.semibold)
                            
                            Spacer()
                        }
                        
                        HStack {
                            
                            
                            Button {
                                likedCommentAlerts.toggle()
                            } label: {
                                Text("New Like")
                                    .foregroundStyle(Color(.systemGray))
                                
                                Spacer()
                                
                                if likedCommentAlerts {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundStyle(Color(.green))
                                } else {
                                    Image(systemName: "circle")
                                        .foregroundStyle(colorScheme == .dark ? Theme.buttonColorDarkMode : Theme.buttonColor)
                                }
                            }
                        }
                        .padding(.leading)
                        
                        HStack {
                            Text("Community Alerts")
                                .foregroundStyle(colorScheme == .dark ? Theme.textColorDarkMode : Theme.textColor)
                                .fontWeight(.semibold)
                            
                            Spacer()
                        }
                        
                        HStack {
                            
                            
                            Button {
                                communityInviteAlerts.toggle()
                            } label: {
                                Text("New Invite")
                                    .foregroundStyle(Color(.systemGray))
                                
                                Spacer()
                                
                                if communityInviteAlerts {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundStyle(Color(.green))
                                } else {
                                    Image(systemName: "circle")
                                        .foregroundStyle(colorScheme == .dark ? Theme.buttonColorDarkMode : Theme.buttonColor)
                                }
                            }
                        }
                        .padding(.leading)
                        
                        HStack {
                            
                            
                            Button {
                                communityMessageAlerts.toggle()
                            } label: {
                                Text("New Message")
                                    .foregroundStyle(Color(.systemGray))
                                
                                Spacer()
                                
                                if communityMessageAlerts {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundStyle(Color(.green))
                                } else {
                                    Image(systemName: "circle")
                                        .foregroundStyle(colorScheme == .dark ? Theme.buttonColorDarkMode : Theme.buttonColor)
                                }
                            }
                        }
                        .padding(.leading)
                         
                    }
                    .padding(.horizontal)
                } else {
                    Spacer()
                    ProgressView()
                }
                
                Spacer()
                
            }
        }
        .onAppear {
            Task {
                do {
                    notificationSettings = try await FetchService.fetchNotificationSettings(user: user)
                } catch {
                    notificationSettings = nil
                }
                
                if notificationSettings == nil {
                    await UserService.startUserNotificationSettings(user: user)
                    notificationSettings = try await FetchService.fetchNotificationSettings(user: user)
                    
                }
                
                if let notificationSettings = notificationSettings {
                    if let followAlerts = notificationSettings.followAlerts {
                        self.followAlerts = followAlerts
                    }
                    
                    if let likedPostAlerts = notificationSettings.likedPostAlerts {
                        self.likedPostAlerts = likedPostAlerts
                    }
                    
                    if let commentedPostAlerts = notificationSettings.commentedPostAlerts {
                        self.commentedPostAlerts = commentedPostAlerts
                    }
                    
                    if let likedCommentAlerts = notificationSettings.likedCommentAlerts {
                        self.likedCommentAlerts = likedCommentAlerts
                    }
                    
                    if let communityInviteAlerts = notificationSettings.communityInviteAlerts {
                        self.communityInviteAlerts = communityInviteAlerts
                    }
                    
                    if let communityMessageAlerts = notificationSettings.communityMessageAlerts {
                        self.communityMessageAlerts = communityMessageAlerts
                    }
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
    }
}

