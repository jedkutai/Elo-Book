//
//  GroupMessageThreadView.swift
//  Elo Book
//
//  Created by Jed Kutai on 1/11/24.
//

import SwiftUI
import Kingfisher
import PhotosUI
import UIKit

struct GroupMessageThreadView: View {
    @State var thread: Thread
    @State var user: User
    
    @State private var message = ""
    
    @State private var receivingUsers: [User]?
    @State private var messages: [Message] = []
    @State private var selectedImages: [PhotosPickerItem] = []
    @State private var messageSettings = [String: GroupMessageSettings]()
    
    @State private var sendingMessage = false
    @State private var photoPickerPresented = false
    @State private var refresh = false
    @State private var messageRefreshTicker = false
    @State private var canTick = false
    @State private var leftGroup = false
    @State private var tickCount = 0
    
    
    @State private var swipeStarted = false
    @StateObject private var viewModel = UploadMessage()
    
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.dismiss) private var dismiss
    var body: some View {
        NavigationStack {
            VStack {
                
                if let receivingUsers = receivingUsers {
                    GroupMessageThreadViewHeader(thread: $thread, user: $user, receivingUsers: receivingUsers, leftGroup: $leftGroup, refresh: $refresh, dismiss: dismiss)
                    
                    Divider()
                        .frame(height: 1)
                    
                    
                    
                    // body
                    ScrollView(.vertical, showsIndicators: false) {
                        LazyVStack {
                            ForEach(messages, id: \.id) { message in
                                Group {
                                    if let messageUserIndex = receivingUsers.firstIndex(where: { $0.id == message.userId}) {
                                        if let settings = messageSettings[message.id] {
                                            VStack {
                                                if settings.showTime {
                                                    HStack {
                                                        Spacer()
                                                        Text("\(DateFormatter.longDate(timestamp: message.timestamp))")
                                                            .font(.footnote)
                                                            .foregroundStyle(Color(.systemGray))
                                                        Spacer()
                                                    }
                                                    .padding(.vertical, 10)
                                                }
                                                GroupMessageCell(message: message, messageUser: receivingUsers[messageUserIndex], user: user, messageSetting: settings)
                                                    .padding(.vertical, 2.5)
                                                
                                            }
                                            
                                        }
                                    }
                                }
                                .rotationEffect(Angle(degrees: 180)).scaleEffect(x: -1.0, y: 1.0, anchor: .center)
                                
                            }
                            .padding(.horizontal, 5)
                            
                        }
                    }
                    .rotationEffect(Angle(degrees: 180)).scaleEffect(x: -1.0, y: 1.0, anchor: .center)
                    .onTapGesture {
                        hideKeyboard()
                    }
                    .scrollDismissesKeyboard(.interactively)
                    
                    
                    
                    
                    
                    
                    
                    if !leftGroup {
                        MessageThreadTextBoxView(photoPickerPresented: $photoPickerPresented, sendingMessage: $sendingMessage, message: $message, user: $user, users: receivingUsers, refresh: $refresh, viewModel: viewModel)
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
        .onAppear {
            Task {
                pageRefresh()
                canTick = true
                print(messages.count)
            }
        }
        .onChange(of: refresh) {
            Task {
                pageRefresh()
                print("refresh group thread")
            }
        }
        .onDisappear {
            canTick = false
        }
        .onChange(of: messageRefreshTicker) {
            if canTick { // change false to can tick after done making the page
                DispatchQueue.main.asyncAfter(deadline: .now() + 15.0) { // make timer 15 seconds?
                    print("tick \(tickCount)")
                    tickCount += 1
                    pageRefresh()
                    messageRefreshTicker.toggle()
                }
                
            }
        }
        .photosPicker(isPresented: $photoPickerPresented, selection: $selectedImages, maxSelectionCount: 4)
        .onChange(of: selectedImages) {
            viewModel.messageImages = []
            viewModel.uiImages = []
            
            Task {
                await viewModel.loadImages(fromItem: selectedImages)
            }
        }
        
    }
    
    private func getGroupChatTitle(threadUsers: [User]) -> String {
        var usernamesArray: [String] = []
        
        for user in threadUsers {
            if let username = user.username {
                usernamesArray.append(username)
            }
        }
        
        usernamesArray = usernamesArray.sorted()
        let usernames = usernamesArray.joined(separator: ", ")
        
        return usernames
    }
    
    private func pageRefresh() {
        Task {
            receivingUsers = try await FetchService.fetchUsersByUserIds(userIds: thread.userIds) /*+ [user]*/
            
            messages = try await FetchService.fetchMessagesByThreadId(threadId: thread.id)
            
            var lastUserId = ""
            var lastMessageId = ""
            var lastDate = Date()
            for message in messages.reversed() {
                if lastUserId.isEmpty {
                    lastDate = message.timestamp.dateValue()
                    lastUserId = message.userId
                    lastMessageId = message.id
                    messageSettings[lastMessageId] = GroupMessageSettings(showUsername: true, showProfileImage: true, showTime: true)
                } else {
                    let currentDate = message.timestamp.dateValue()
                    let timeDifference = currentDate.timeIntervalSince(lastDate)
                    if timeDifference >= 3600 {
                        messageSettings[message.id] = GroupMessageSettings(showUsername: true, showProfileImage: true, showTime: true)
                    } else {
                        if message.userId == lastUserId {
                            messageSettings[lastMessageId]?.showProfileImage = false
                            messageSettings[message.id] = GroupMessageSettings(showUsername: false, showProfileImage: true, showTime: false)
                        } else {
                            messageSettings[message.id] = GroupMessageSettings(showUsername: true, showProfileImage: true, showTime: false)
                        }
                        
                    }
                    
                    lastDate = message.timestamp.dateValue()
                    lastUserId = message.userId
                    lastMessageId = message.id
                }
            }
            
        }
    }
}

