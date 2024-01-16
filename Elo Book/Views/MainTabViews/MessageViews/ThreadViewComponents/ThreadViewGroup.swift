//
//  ThreadViewGroup.swift
//  Elo Book
//
//  Created by Jed Kutai on 1/13/24.
//

import SwiftUI
import PhotosUI
import UIKit

struct ThreadViewGroup: View {
    @State var user: User
    @State var threadUsers: [User]
    @State var thread: Thread
    @StateObject var messagesManager: MessageManager
    
    var dismiss: DismissAction
    
    @State private var message = ""
    @State private var photosPickerPresented = false
    @State private var showMessageImages = true
    @State private var selectedImages: [PhotosPickerItem] = []
    @StateObject private var viewModel = UploadMessage()
    
    @Environment(\.colorScheme) var colorScheme
    var body: some View {
        VStack {
            // header (dismiss button, group icon with their name below it -> link to profile, info.circle for info page
            HStack {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                        .foregroundStyle(colorScheme == .dark ? Theme.buttonColorDarkMode : Theme.buttonColor)
                }
                
                Spacer()
                
                VStack {
                    SquareGroupChatPicture(thread: thread, size: .shmedium)
                    
                    if let threadName = thread.threadName {
                        Text(threadName)
                            .fontWeight(.bold)
                            .foregroundStyle(colorScheme == .dark ? Theme.textColorDarkMode : Theme.textColor)
                    } else {
                        Text(self.createThreadTitle(users: threadUsers))
                            .fontWeight(.bold)
                            .foregroundStyle(colorScheme == .dark ? Theme.textColorDarkMode : Theme.textColor)
                    }
                }
                
                Spacer()
                
                NavigationLink {
                    Text("Under Construction")
                        .foregroundStyle(colorScheme == .dark ? Theme.textColorDarkMode : Theme.textColor)
                  // this page will have a list of all the group members and will allow you to add users or leave the group
                    // add warning saying new users can see old messages
                } label: {
                    Image(systemName: "info.circle")
                        .foregroundStyle(colorScheme == .dark ? Theme.buttonColorDarkMode : Theme.buttonColor)
                }
            }
            
            Divider()
                .frame(height: 1)
            
            ScrollViewReader { proxy in
                ScrollView(.vertical, showsIndicators: false) {
                    ForEach(messagesManager.messages, id: \.id) { message in
                        if let messageInfo = messagesManager.messagesInfo[message.id] {
                            if message.userId == user.id {
                                MessageDisplayer(user: user, messageUser: user, message: message, messageInfo: messageInfo, isGroupMessage: true)
                            } else if let userIndex = threadUsers.firstIndex(where: { $0.id == message.userId}) {
                                
                                MessageDisplayer(user: user, messageUser: threadUsers[userIndex], message: message, messageInfo: messageInfo, isGroupMessage: true)
                            }
                            
                            
                        }
                    }
                }
                .onAppear(perform: {
                    proxy.scrollTo(messagesManager.lastMessageId, anchor: .bottom)
                })
                .onChange(of: messagesManager.lastMessageId, { oldId, newId in
                    withAnimation {
                        proxy.scrollTo(newId, anchor: .bottom)
                    }
                })
                .scrollDismissesKeyboard(.immediately)
                
            }
            
            // keyboard
            VStack {
                HStack { // display selected images
                    if !viewModel.uiImages.isEmpty && showMessageImages {
                        ScrollView(.horizontal, showsIndicators: false) {
                            LazyHStack {
                                ForEach(viewModel.uiImages, id: \.self) { image in
                                    Image(uiImage: image)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(height: 70)
                                        .padding(.leading, 1)
                                }
                            }
                        }
                        .frame(height: 70)
                        .padding(.horizontal)
                        
                        Divider()
                            .frame(height: 1)
                    }
                }
                
                HStack {
                    Button {
                        photosPickerPresented.toggle()
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .foregroundStyle(colorScheme == .dark ? Theme.textColorDarkMode : Theme.textColor)
                    }
                    
                    TextField("Message", text: $message, axis: .vertical)
                        .font(.footnote)
                        
                    
                    Spacer()
                    
                    Group {
                        if (Checks.isValidCaption(message) || (message.isEmpty && !viewModel.messageImages.isEmpty))  {
                            Button {
                                showMessageImages.toggle()
                                let captionToBeSent = message
                                message = ""
                                Task {
                                    if !viewModel.messageImages.isEmpty {
//                                        try await viewModel.uploadMessageImages(user: user, receivingUsers: threadUsers)
                                        try await viewModel.uploadMessageImagesViaThread(user: user, thread: thread)
                                    }
                                    if Checks.isValidCaption(captionToBeSent) {
//                                        try await viewModel.uploadMessageCaption(user: user, receivingUsers: threadUsers, caption: captionToBeSent)
                                        try await viewModel.uploadMessageCaptionViaThread(user: user, thread: thread, caption: captionToBeSent)
                                    }
                                    
                                }
                                
                            } label: {
                                Image(systemName: "arrow.up.circle.fill")
                                    .foregroundStyle(Color(.systemBlue))
                            }
                        } else {
                            Image(systemName: "arrow.up.circle.fill")
                                .foregroundStyle(Color(.lightGray))
                        }
                    }
                    .padding(.horizontal, 5)
                }
            }
            .padding(10)
            .background(
                RoundedRectangle(cornerRadius: 15)
                    .stroke(Color(.gray).opacity(0.3), lineWidth: 1)
            )
            .padding(10)
        }
        .photosPicker(isPresented: $photosPickerPresented, selection: $selectedImages, maxSelectionCount: 4)
        .onChange(of: selectedImages) {
            viewModel.uiImages = []
            viewModel.messageImages = []
            Task {
                await viewModel.loadImages(fromItem: selectedImages)
            }
        }
        .onSubmit {
            if (Checks.isValidCaption(message) || (message.isEmpty && !viewModel.messageImages.isEmpty))  {
                showMessageImages.toggle()
                let captionToBeSent = message
                message = ""
                Task {
                    if !viewModel.messageImages.isEmpty {
                        try await viewModel.uploadMessageImages(user: user, receivingUsers: threadUsers)
                    }
                    if Checks.isValidCaption(captionToBeSent) {
                        try await viewModel.uploadMessageCaption(user: user, receivingUsers: threadUsers, caption: captionToBeSent)
                    }
                    
                }
            }
        }
    }
    
    private func createThreadTitle(users: [User]) -> String {
        var usernames: [String] = []
        for user in users {
            if let username = user.username {
                if !usernames.contains(username) {
                    usernames.append(username)
                }
            }
        }
        
        let title = usernames.joined(separator: ", ")
        
        
        return title
    }
}

