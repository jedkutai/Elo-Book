//
//  CreatePostController.swift
//  EloBookv1
//
//  Created by Jed Kutai on 12/24/23.
//

import SwiftUI
import PhotosUI
import UIKit

enum createPostViewShown {
    case createPost
    case addEvents
}

struct CreatePostController: View {
    @State var user: User
    @Binding var postCreated: Bool
    @State var events: [Event] = []
    
    @State private var caption = ""
    @State private var searchText = ""
    
    
    @State private var currentView: createPostViewShown = .createPost
    
    @State private var imagePickerPresented = false
    @State private var posting = false
    @State private var isCropViewPresented = false
    @State private var showCrop = false
    
    @State private var selectedImages: [PhotosPickerItem] = []
    @State private var eventSearchResults: [Event] = []
    @State private var allEvents: [Event] = []
    
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel = UploadPost()
    
    var body: some View {
        switch currentView {
        case .createPost:
            CreatePostView(isCropViewPresented: $isCropViewPresented, posting: $posting, currentView: $currentView, selectedImages: $selectedImages, caption: $caption, viewModel: viewModel, dismiss: dismiss)
        case .addEvents:
            AddEventsView(posting: $posting, currentView: $currentView, events: $events, eventSearchResults: $eventSearchResults, caption: $caption, searchText: $searchText, viewModel: viewModel, user: $user, postCreated: $postCreated, dismiss: dismiss)
        }
    }
}
