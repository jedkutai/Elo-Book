//
//  EventChatRoomView.swift
//  Elo Book
//
//  Created by Jed Kutai on 1/14/24.
//

//import SwiftUI
//
//struct EventChatRoomView: View {
//    @State var user: User
//    @State var event: Event
//    @StateObject var eventChatManager: EventChatManager
//    
//    init(user: User, event: Event) { // need this to initialize messagesmanager
//        self._user = State(initialValue: user)
//        self._event = State(initialValue: event)
//        self._eventChatManager = StateObject(wrappedValue: EventChatManager(event: event, user: user))
//    }
//    
//    @State private var message = ""
//    @State private var viewModel = UploadMessage()
//    @State private var threadUsers = [String: User]()
//    @Environment(\.colorScheme) var colorScheme
//    @Environment(\.dismiss) var dismiss
//    var body: some View {
//        NavigationStack {
//            VStack {
//                HStack {
//                    Button {
//                        dismiss()
//                    } label: {
//                        Image(systemName: "chevron.left")
//                            .foregroundColor(colorScheme == .dark ? Theme.buttonColorDarkMode : Theme.buttonColor)
//                    }
//                    
//                    Spacer()
//                    
//                    MiniEventCell(event: event)
//                    
//                    Spacer()
//                    
//                    Image(systemName: "chevron.left")
//                        .foregroundColor(Color(.clear))
//                }
//                .padding(.horizontal)
//                
//                Divider()
//                    .frame(height: 1)
//                
//                ScrollViewReader { proxy in
//                    ScrollView(.vertical, showsIndicators: false) {
//                        ForEach(eventChatManager.messages, id: \.id) { message in
//                            if let messageInfo = eventChatManager.messagesInfo[message.id] {
//                                if message.userId == user.id {
//                                    ChatMessageDisplayer(user: user, messageUser: user, message: message, messageInfo: messageInfo, isGroupMessage: true)
//                                } else if let messageUser = threadUsers[message.userId] {
//                                    
//                                    ChatMessageDisplayer(user: user, messageUser: messageUser, message: message, messageInfo: messageInfo, isGroupMessage: true)
//                                }
//                                
//                                
//                            }
//                        }
//                    }
//                    .onAppear(perform: {
//                        proxy.scrollTo(eventChatManager.lastMessageId, anchor: .bottom)
//                    })
//                    .onChange(of: eventChatManager.lastMessageId, { oldId, newId in
//                        withAnimation {
//                            proxy.scrollTo(newId, anchor: .bottom)
//                        }
//                    })
//                    .scrollDismissesKeyboard(.immediately)
//                    
//                }
//                
//                // keyboard
//                HStack {
//                    Image(systemName: "plus.circle.fill")
//                        .foregroundStyle(Color(.clear))
//                    
//                    TextField("Message", text: $message, axis: .vertical)
//                        .font(.footnote)
//                        
//                    
//                    Spacer()
//                    
//                    Group {
//                        if Checks.isValidCaption(message) {
//                            Button {
//                                let captionToBeSent = message
//                                message = ""
//                                Task {
//                                    if Checks.isValidCaption(captionToBeSent) {
//                                        try await viewModel.uploadMessageCaptionViaEvent(user: user, event: event, caption: captionToBeSent)
//                                    }
//                                    
//                                }
//                                
//                            } label: {
//                                Image(systemName: "arrow.up.circle.fill")
//                                    .foregroundStyle(Color(.systemBlue))
//                            }
//                        } else {
//                            Image(systemName: "arrow.up.circle.fill")
//                                .foregroundStyle(Color(.lightGray))
//                        }
//                    }
//                    .padding(.horizontal, 5)
//                }
//                .padding(10)
//                .background(
//                    RoundedRectangle(cornerRadius: 15)
//                        .stroke(Color(.gray).opacity(0.3), lineWidth: 1)
//                )
//                .padding(10)
//                
//            }
//            .onChange(of: eventChatManager.chatterIds) { _ , newChatterId in
//                for userId in newChatterId {
//                    if threadUsers[userId] == nil {
//                        Task {
//                            threadUsers[userId] = try await FetchService.fetchUserById(withUid: userId)
//                        }
//                    }
//                }
//            }
//            .onSubmit {
//                if Checks.isValidCaption(message)  {
//                    let captionToBeSent = message
//                    message = ""
//                    Task {
//                        if Checks.isValidCaption(captionToBeSent) {
//                            try await viewModel.uploadMessageCaptionViaEvent(user: user, event: event, caption: captionToBeSent)
//                        }
//                    }
//                }
//            }
//        }
//    }
//}
