//
//  CreateStandardMessageView.swift
//  Elo Book
//
//  Created by Jed Kutai on 1/10/24.
//

import SwiftUI
import PhotosUI
import UIKit

struct CreateStandardMessageView: View {
    @Binding var user: User
    @State private var message = ""
    @State private var searchText = ""
    @State private var searchDatabaseText = ""
    
    @State private var sendingMessage = false
    @State private var photoPickerPresented = false
    
    @State private var recievingUsers: [User] = []
    @State private var someUsers: [User] = []
    
    @State private var usernameSearchResults: [User] = []
    
    @State private var selectedImages: [PhotosPickerItem] = []
    
    
    @StateObject private var viewModel = UploadMessage()
    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) var colorScheme
    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    Button {
                        dismiss()
                    } label: {
                        Text("Cancel")
                            .font(.footnote)
                            .foregroundStyle(Color(.systemRed))
                    }
                    
                    Spacer()
                    
                    Text("NEW MESSAGE")
                        .font(.footnote)
                        .fontWeight(.bold)
                        .foregroundStyle(colorScheme == .dark ? Theme.textColorDarkMode : Theme.textColor)
                    
                    Spacer()
                    
                    Text("Cancel")
                        .font(.footnote)
                        .foregroundStyle(Color.clear) // invisible
                }
                .padding(.horizontal)
                
                CreateMessageReceivingUsers(recievingUsers: $recievingUsers)
                
                CreateMessageSearchBar(searchText: $searchText, user: $user, usernameSearchResults: $usernameSearchResults, recievingUsers: $recievingUsers)
                
                Spacer()
                
                CreateStandardMessageTextBox(message: $message, photoPickerPresented: $photoPickerPresented, sendingMessage: $sendingMessage, viewModel: viewModel, user: $user, recievingUsers: $recievingUsers, dismiss: dismiss)
            }
            .photosPicker(isPresented: $photoPickerPresented, selection: $selectedImages, maxSelectionCount: 4)
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
                    searchDatabaseText = String(searchText.prefix(2))
                }
                
                usernameSearchResults = SearchService.searchLocallyForUsernames(searchText: searchText, users: someUsers, limit: 10)
            }
            .onChange(of: searchDatabaseText) {
                if !searchDatabaseText.isEmpty {
                    if Checks.isValidSearch(searchDatabaseText) {
                        Task {
                            someUsers = try await SearchService.searchDatabaseForUsernames(searchTerm: searchDatabaseText)
                        }
                    }
                }
            }
        }
    }
}
