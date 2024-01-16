//
//  CreateNewMessageView.swift
//  Elo Book
//
//  Created by Jed Kutai on 1/12/24.
//

import SwiftUI
import PhotosUI
import UIKit

struct CreateNewMessageView: View {
    @State var user: User
    
    @State private var message = ""
    @State private var searchText = ""
    @State private var searchDatabaseText = ""
    
    @State private var sendingMessage = false
    @State private var photosPickerPresented = false
    @State private var showMessageImages = true
    
    @State private var receivingUsers: [User] = [] // don't make optional
    @State private var someUsers: [User] = []
    @State private var filteredUsers: [User] = []
    @State private var selectedImages: [PhotosPickerItem] = []
    
    @StateObject private var viewModel = UploadMessage()
    
    
    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) var colorScheme
    var body: some View {
        NavigationStack {
            VStack {
                // header
                CreateNewMessageViewHeader(dismiss: dismiss)
                
                // bar that shows everyone that is being added to the thread
                CreateNewMessageViewReceivingUsers(receivingUsers: $receivingUsers)
                
                // search bar
                CreateNewMessageViewSearchBar(searchText: $searchText)
                
                // search results
                CreateNewMessageViewSearchResults(user: $user, filteredUsers: $filteredUsers, receivingUsers: $receivingUsers, searchText: $searchText)
                
                Spacer()
                
                
                // text box
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
                        if sendingMessage {
                            ProgressView()
                        }
                        
                        Group {
                            if (Checks.isValidCaption(message) || (message.isEmpty && !viewModel.messageImages.isEmpty)) && !receivingUsers.isEmpty {
                                Button {
                                    showMessageImages.toggle()
                                    sendingMessage.toggle()
                                    let captionToBeSent = message
                                    message = ""
                                    Task {
                                        if !viewModel.messageImages.isEmpty {
                                            try await viewModel.uploadMessageImages(user: user, receivingUsers: receivingUsers)
                                        }
                                        if Checks.isValidCaption(captionToBeSent) {
                                            try await viewModel.uploadMessageCaption(user: user, receivingUsers: receivingUsers, caption: captionToBeSent)
                                        }
                                        
                                    }
                                    dismiss()
                                    
                                } label: {
                                    Image(systemName: "arrow.up.circle.fill")
                                        .foregroundStyle(Color(.systemBlue))
                                }
                            } else if sendingMessage {
                                ProgressView()
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
        }
        .photosPicker(isPresented: $photosPickerPresented, selection: $selectedImages, maxSelectionCount: 4)
        .onChange(of: selectedImages) {
            viewModel.uiImages = []
            viewModel.messageImages = []
            Task {
                await viewModel.loadImages(fromItem: selectedImages)
            }
        }
        .onChange(of: searchText) {
            if searchText.count < 1 {
                searchDatabaseText = ""
            } else if searchText.count >= 1 {
                searchDatabaseText = String(searchText.prefix(1))
            }
            
            filteredUsers = SearchService.searchLocallyForUsernames(searchText: searchText, users: someUsers, limit: 10)
        }
        .onChange(of: searchDatabaseText) {
            if !searchDatabaseText.isEmpty {
                if Checks.isValidSearch(searchDatabaseText) {
                    Task {
                        someUsers = try await SearchService.searchDatabaseForUsernames(searchTerm: searchDatabaseText)
                    }
                } else {
                    someUsers = []
                }
            } else {
                someUsers = []
            }
        }
        
    }
}

