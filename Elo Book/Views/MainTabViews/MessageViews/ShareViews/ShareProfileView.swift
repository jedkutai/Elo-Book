//
//  ShareProfileView.swift
//  Elo Book
//
//  Created by Jed Kutai on 1/16/24.
//

import SwiftUI

struct ShareProfileView: View {
    @State var user: User
    @State var userToShare: User
    
    
    @State private var message = ""
    @State private var searchText = ""
    @State private var searchDatabaseText = ""
    
    @State private var sendingMessage = false
    
    @State private var receivingUsers: [User] = [] // don't make optional
    
    @StateObject private var viewModel = UploadMessage()
    
    
    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) var colorScheme
    var body: some View {
        NavigationStack {
            VStack {
                // header
//                CreateNewMessageViewHeader(dismiss: dismiss)
                
                // bar that shows everyone that is being added to the thread
                CreateNewMessageViewReceivingUsers(receivingUsers: $receivingUsers)
                
                // search bar
                CreateNewMessageViewSearchBar(searchText: $searchText)
                
                // search results
                CreateNewMessageViewSearchResults(user: $user, receivingUsers: $receivingUsers, searchText: $searchText)
                
                Spacer()
                
                
                // text box
                VStack {
                    HStack { // display post that is going to be shared
                        StaticUserProfile(user: user, userToShare: userToShare)
                        
                    }
                    
                    Divider()
                        .frame(height: 1)
                    
                    HStack {
                        
                        TextField("Message", text: $message, axis: .vertical)
                            .padding(.vertical, 2.5)
                            
                        
                        Spacer()
                        if sendingMessage {
                            ProgressView()
                        }
                        
                        Group {
                            if (Checks.isValidCaption(message) || message.isEmpty) && !receivingUsers.isEmpty {
                                Button {
                                    sendingMessage.toggle()
                                    let captionToBeSent = message
                                    message = ""
                                    Task {
                                        try await viewModel.uploadMessageSharedProfile(user: user, receivingUsers: receivingUsers, sharedUser: userToShare)
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
            .navigationTitle("Share Profile").foregroundStyle(colorScheme == .dark ? Theme.textColorDarkMode : Theme.textColor)
            .toolbarTitleDisplayMode(.inline)
        }
        
    }
}
