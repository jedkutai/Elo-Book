//
//  CreatePostMasterView.swift
//  Elo Book
//
//  Created by Jed Kutai on 1/6/24.
//

import SwiftUI
import PhotosUI
import UIKit

struct CreatePostMasterView: View {
    @State var user: User
    @Binding var postCreated: Bool
    
    @StateObject private var viewModel = UploadPost()
    @State private var selectedImages: [PhotosPickerItem] = []
    @State var selectedEvents: [Event] = []
    @State private var caption: String = ""
    @State private var searchText: String = ""
    @State private var posting: Bool = false
    @State private var showEvents: Bool = false
    @State private var showPhotosPicker: Bool = false
    
    var filteredEvents: [Event] {
        guard !searchText.isEmpty else { return x.events }
        return x.events.filter { event in
            return event.title.localizedCaseInsensitiveContains(searchText)
        }
    }
    
    @EnvironmentObject var x: X
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.dismiss) private var dismiss
    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    Button {
                        dismiss()
                    } label: {
                        Text("Cancel")
                            .foregroundStyle(Color(.systemRed))
                    }
                    
                    
                    Spacer()
                    
                    if (!viewModel.postImages.isEmpty && caption.isEmpty) || Checks.isValidCaption(caption)  {
                        Button {
                            posting.toggle()
                            Task {
                                try await viewModel.uploadPost(user: user, caption: caption, events: selectedEvents)
                            }
                            
                            dismiss()
                            postCreated.toggle()
                        } label: {
                            Text("Post")
                                .foregroundColor(.blue)
                        }
                    } else {
                        Text("Post")
                            .foregroundColor(.gray)
                    }
                }
                .padding(.horizontal)
                
                ScrollView {
                    
                    PostPreview(user: $user, caption: $caption, selectedEvents: $selectedEvents, viewModel: viewModel)
                        .padding(.top, 5)
                    
                    Button {
                        showPhotosPicker.toggle()
                    } label: {
                        Label("Add Photos", systemImage: "photo.stack")
                            .foregroundStyle(Color(.systemBlue))
                    }
                }
                .scrollDismissesKeyboard(.immediately)
                
                Spacer()
                
                HStack {
                    Button {
                        showEvents.toggle()
                    } label: {
                        Text(showEvents ? "Hide Events" : "Tag Events")
                            .foregroundStyle(Color(.systemBlue))
                    }
                }
                
                if showEvents {
                    ScrollView {
                        LazyVStack {
                            ForEach(filteredEvents, id: \.id) { event in
                                Button {
                                    if !selectedEvents.contains(where: { $0.id == event.id }) && selectedEvents.count < 10 {
                                        selectedEvents.append(event)
                                    } else {
                                        selectedEvents.removeAll(where: { $0.id == event.id } )
                                    }
                                } label: {
                                    HStack {
                                        Spacer()
                                        EventCell(event: event)
                                        Spacer()

                                    }
                                    .padding(5)
                                    .background(
                                        RoundedRectangle(cornerRadius: 5)
                                            .stroke(selectedEvents.contains(where: { $0.id == event.id }) ? Color(.systemBlue) : Color(.gray).opacity(0.3), lineWidth: 1)
                                    )
                                    .padding(.horizontal)
                                }
                            }
                        }
                    }
                }
                
                
                CreatePostMasterTextBox(showEvents: $showEvents, searchText: $searchText, caption: $caption, posting: $posting)
                
                
            }
            .onAppear {
                if x.firstEventSearch {
                    x.firstEventSearch.toggle()
                    Task {
                        x.events = try await FetchService.fetchRecentEvents()
                    }
                }
            }
        }
        .photosPicker(isPresented: $showPhotosPicker, selection: $selectedImages, maxSelectionCount: 4)
        .onChange(of: selectedImages) {
            viewModel.uiImages = []
            viewModel.postImages = []
            Task {
                await viewModel.loadImages(fromItem: selectedImages)
            }
        }

    }
}
