//
//  AddEventsView.swift
//  EloBookv1
//
//  Created by Jed Kutai on 12/24/23.
//

import SwiftUI

struct AddEventsView: View {
    @Binding var posting: Bool
    @Binding var currentView: createPostViewShown
    @Binding var events: [Event]
    @Binding var eventSearchResults: [Event]
    @Binding var caption: String
    @Binding var searchText: String
    @ObservedObject var viewModel: UploadPost
    @Binding var user: User
    @Binding var postCreated: Bool
    var dismiss: DismissAction
    @EnvironmentObject var x: X
    @Environment(\.colorScheme) var colorScheme
    var body: some View {
        NavigationStack {
            ScrollView(.vertical, showsIndicators: false) {
                VStack {
                    HStack {
                        Text("\(events.count) Events:")
                            .padding(5)
                            .foregroundStyle(colorScheme == .dark ? Theme.textColorDarkMode : Theme.textColor)
                            .fontWeight(.bold)
                            .background(
                                RoundedRectangle(cornerRadius: 2.5)
                                    .foregroundStyle(Color(.gray).opacity(0.3))
                            )
                        
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            LazyHStack {
                                ForEach(events, id: \.id) { event in
                                    EventCell(event: event)
                                        .padding(5)
                                        .background(
                                            RoundedRectangle(cornerRadius: 2.5)
                                                .stroke(Color(.systemBlue), lineWidth: 1)
                                        )
                                }
                            }
                        }
                        
                        Spacer()
                        
                    }
                    .padding()
                    
                    Text("Maximum of 10 Events.")
                        .foregroundStyle(events.count < 10 ? Theme.textColor : Color(.systemRed))
                        .font(.footnote)
                    
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                        
                        TextField("Add Events", text: $searchText)
                            .autocapitalization(.none)
                        
                        Spacer()
                    
                    }
                    .padding(5)
                    .background(
                        RoundedRectangle(cornerRadius: 15)
                            .stroke(Color(.gray).opacity(0.3), lineWidth: 1)
                    )
                    .padding(.horizontal, 5)
                    
                    ScrollView(.vertical, showsIndicators: false) {
                        ForEach(eventSearchResults, id: \.id) { event in
                            Button {
                                if !events.contains(where: { $0.id == event.id }) && events.count < 10 {
                                    events.append(event)
                                } else {
                                    if let indexToRemove = events.firstIndex(where: { $0.id == event.id }) {
                                        events.remove(at: indexToRemove)
                                    }
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
                                        .stroke(events.contains(where: { $0.id == event.id }) ? Color(.systemBlue) : Color(.gray).opacity(0.3), lineWidth: 1)
                                )
                                .padding(.horizontal)
                            }
                        }
                    }
                    
                    Spacer()
                }
            }
            .navigationTitle("Tag Events")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        currentView = .createPost
                    } label: {
                        Image(systemName: "chevron.left")
                            .foregroundStyle(colorScheme == .dark ? Theme.textColorDarkMode : Theme.textColor)
                    }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    if posting {
                        ProgressView()
                    }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    if (!viewModel.postImages.isEmpty && caption.isEmpty) || Checks.isValidCaption(caption)  {
                        Button {
                            posting.toggle()
                            Task {
                                try await viewModel.uploadPost(user: user, caption: caption, events: events)
                            }
                            
                            dismiss()
                            postCreated.toggle()
                        } label: {
                            Text("Post")
                                .foregroundColor(.blue)
                        }
                    } else {
                        Text("Post")
                            .foregroundColor(.red)
                    }
                }

            }
        }
        .onChange(of: searchText) {
            eventSearchResults = SearchService.searchLocallyForEvents(in: x.events, for: searchText)
        }
        .onAppear {
            if x.firstEventSearch {
                x.firstEventSearch.toggle()
                Task {
                    x.events = try await FetchService.fetchRecentEvents()
                }
            }
        }
        .onTapGesture {
            hideKeyboard()
        }
        .onSubmit {
            hideKeyboard()
        }
    }
}
