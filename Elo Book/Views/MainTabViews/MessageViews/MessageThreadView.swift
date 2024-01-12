//
//  MessageThreadView.swift
//  Elo Book
//
//  Created by Jed Kutai on 1/11/24.
//

import SwiftUI
import PhotosUI
import UIKit
import Kingfisher

struct MessageThreadView: View {
    @State var thread: Thread
    @State var user: User
    
    @State private var message = ""
    
    @State private var sendingMessage = false
    @State private var photoPickerPresented = false
    @State private var refresh = false
    
    @State private var messages: [Message] = []
    @State private var receivingUser: User?
    @State private var selectedImages: [PhotosPickerItem] = []
    
    @State private var messageRefreshTicker = false
    @State private var canTick = false
    @State private var tickCount = 0
    @State private var swipeStarted = false
    @StateObject private var viewModel = UploadMessage()
    @Environment(\.dismiss) private var dismiss
    var body: some View {
        NavigationStack {
            VStack {
                if let receivingUser = receivingUser {
                    MessageThreadHeaderView(user: $user, receivingUser: receivingUser, thread: $thread, dismiss: dismiss)
                    
                    Divider()
                        .frame(height: 1)
                    
                    MessageThreadBodyView(messages: $messages, user: $user, receivingUser: receivingUser)
                    
                    // text box is shared with regular chats and group chats
                    MessageThreadTextBoxView(photoPickerPresented: $photoPickerPresented, sendingMessage: $sendingMessage, message: $message, user: $user, users: [user, receivingUser], refresh: $refresh, viewModel: viewModel)
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
                receivingUser = try await FetchService.fetchMessageUserByThread(thread: thread, user: user)
                messages = try await FetchService.fetchMessagesByThreadId(threadId: thread.id)
                messageRefreshTicker.toggle()
                canTick = true
            }
        }
        .onChange(of: refresh) {
            Task {
                receivingUser = try await FetchService.fetchMessageUserByThread(thread: thread, user: user)
                messages = try await FetchService.fetchMessagesByThreadId(threadId: thread.id)
            }
        }
        .onChange(of: messageRefreshTicker) {
            if canTick { // change false to can tick after done making the page
                Task {
                    receivingUser = try await FetchService.fetchMessageUserByThread(thread: thread, user: user)
                    messages = try await FetchService.fetchMessagesByThreadId(threadId: thread.id)
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 15.0) { // make timer 15 seconds?
                    print("tick \(tickCount)")
                    tickCount += 1
                    messageRefreshTicker.toggle()
                }
                
            }
        }
        .onDisappear {
            canTick = false
        }
        .onChange(of: messageRefreshTicker) {
            if canTick {
                DispatchQueue.main.asyncAfter(deadline: .now() + 15.0) { // make timer 15 seconds?
                    print("timer")
                    Task {
                        print("tick")
                        messages += try await FetchService.fetchMoreMessagesByTime(thread: thread, lastMessage: messages.last)
                        messageRefreshTicker.toggle()
                    }
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
}
