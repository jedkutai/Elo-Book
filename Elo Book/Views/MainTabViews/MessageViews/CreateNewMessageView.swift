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
    
    @State private var recievingUsers: [User]?
    @State private var someUsers: [User] = []
    
    @State private var selectedImages: [PhotosPickerItem] = []
    
    @StateObject private var viewModel = UploadMessage()
    
    var filteredUsers: [User] {
        guard !searchText.isEmpty else { return someUsers }
        return someUsers.filter { user in
            if let username = user.username {
                return username.localizedCaseInsensitiveContains(searchText)
            }
            return false
        }
    }
    
    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) var colorScheme
    var body: some View {
        NavigationStack {
            VStack {
                CreateNewMessageViewHeader(dismiss: dismiss) // header
                // bar that shows everyone that is being added to the thread
                // search bar to add users
                
                ScrollView(.horizontal, showsIndicators: false) {
                    
                }
                .scrollDismissesKeyboard(.interactively)
                
                // text box
            }
        }
        .photosPicker(isPresented: $photosPickerPresented, selection: $selectedImages, maxSelectionCount: 4)
        .onChange(of: selectedImages) {
            viewModel.uiImages = []
            Task {
                await viewModel.loadImages(fromItem: selectedImages)
            }
        }
        .onChange(of: searchText) {
            if searchText.count < 2 {
                searchDatabaseText = ""
            } else if searchText.count >= 2 {
                searchDatabaseText = String(searchText.prefix(2))
            }

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

