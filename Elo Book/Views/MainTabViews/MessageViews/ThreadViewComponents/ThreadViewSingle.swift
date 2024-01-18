//
//  ThreadViewSingle.swift
//  Elo Book
//
//  Created by Jed Kutai on 1/13/24.
//

import SwiftUI
import PhotosUI
import UIKit

struct ThreadViewSingle: View {
    @State var user: User
    @State var threadUser: User
    @State var thread: Thread
    @StateObject var messagesManager: MessageManager
    var dismiss: DismissAction
    
    
    @State private var message = ""
    @State private var photosPickerPresented = false
    @State private var showMessageImages = true
    @State private var doneLoadingMessages = false
    @State private var selectedImages: [PhotosPickerItem] = []
    @StateObject private var viewModel = UploadMessage()
    
    @Environment(\.colorScheme) var colorScheme
    var body: some View {
        VStack {
            
            if doneLoadingMessages {
                ScrollViewReader { proxy in
                    ScrollView(.vertical, showsIndicators: false) {
                        ForEach(messagesManager.messages, id: \.id) { message in
                            if let messageInfo = messagesManager.messagesInfo[message.id] {
                                if message.userId == user.id {
                                    MessageDisplayer(user: user, messageUser: user, message: message, messageInfo: messageInfo, isGroupMessage: false)
                                } else {
                                    MessageDisplayer(user: user, messageUser: threadUser, message: message, messageInfo: messageInfo, isGroupMessage: false)
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
            } else {
                Spacer()
                ProgressView()
                Spacer()
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
                        .padding(.vertical, 2.5)
                        
                    
                    Spacer()
                    
                    Group {
                        if (Checks.isValidCaption(message) || (message.isEmpty && !viewModel.messageImages.isEmpty))  {
                            Button {
                                showMessageImages.toggle()
                                let captionToBeSent = message
                                message = ""
                                Task {
                                    if !viewModel.messageImages.isEmpty {
//                                        try await viewModel.uploadMessageImages(user: user, receivingUsers: [threadUser])
                                        try await viewModel.uploadMessageImagesViaThread(user: user, thread: thread)
                                    }
                                    if Checks.isValidCaption(captionToBeSent) {
//                                        try await viewModel.uploadMessageCaption(user: user, receivingUsers: [threadUser], caption: captionToBeSent)
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
            .padding(.bottom, 10)
            .padding(.horizontal, 10)
            
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                doneLoadingMessages = true
            }
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
                        try await viewModel.uploadMessageImages(user: user, receivingUsers: [threadUser])
                    }
                    if Checks.isValidCaption(captionToBeSent) {
                        try await viewModel.uploadMessageCaption(user: user, receivingUsers: [threadUser], caption: captionToBeSent)
                    }
                    
                }
            }
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                NavigationLink {
                    AltUserProfileView(user: user, viewedUser: threadUser)
                } label: {
                    HStack {
                        SquareProfilePicture(user: threadUser, size: .small)
                        
                        if let fullname = threadUser.fullname {
                            Text(fullname)
                                .fontWeight(.bold)
                                .foregroundStyle(colorScheme == .dark ? Theme.textColorDarkMode : Theme.textColor)
                        }
                        
                        if let username = threadUser.username {
                            Text(username)
                                .foregroundStyle(Color(.systemGray))
                        }
                        
                        if let displayedBadge = threadUser.displayedBadge {
                            BadgeDiplayer(badge: displayedBadge)
                        }
                        
                    }
                }
            }
        }
    }
}

