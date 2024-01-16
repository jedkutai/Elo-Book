//
//  EventChatRoomView.swift
//  Elo Book
//
//  Created by Jed Kutai on 1/14/24.
//

import SwiftUI

struct EventChatRoomView: View {
    @State var user: User
    @State var event: Event
    @StateObject var eventChatManager: EventChatManager
//    @State private var viewModel: UploadChat
    
    init(user: User, event: Event) { // need this to initialize messagesmanager
        self._user = State(initialValue: user)
        self._event = State(initialValue: event)
        self._eventChatManager = StateObject(wrappedValue: EventChatManager(event: event))
    }
    
    @State private var message = ""
    
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.dismiss) var dismiss
    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "chevron.left")
                            .foregroundColor(colorScheme == .dark ? Theme.buttonColorDarkMode : Theme.buttonColor)
                    }
                    
                    Spacer()
                    
                    MiniEventCell(event: event)
                    
                    Spacer()
                    
                    Image(systemName: "chevron.left")
                        .foregroundColor(Color(.clear))
                }
                .padding(.horizontal)
                
                Divider()
                    .frame(height: 1)
                
                ScrollViewReader { proxy in
                    ScrollView(.vertical, showsIndicators: false) {
                        ForEach(eventChatManager.chats, id: \.id) { chat in
                            ChatMessageDisplayer(user: user, chat: chat)
                        }
                    }
                    .onAppear(perform: {
                        proxy.scrollTo(eventChatManager.lastChatId, anchor: .bottom)
                    })
                    .onChange(of: eventChatManager.lastChatId, { oldId, newId in
                        withAnimation {
                            proxy.scrollTo(newId, anchor: .bottom)
                        }
                    })
                    .scrollDismissesKeyboard(.immediately)
                    
                }
                
                // keyboard
                HStack {
                    
                    TextField("Message", text: $message, axis: .vertical)
                        .font(.footnote)
                        
                    
                    Spacer()
                    
                    Group {
                        if Checks.isValidCaption(message) {
                            Button {
                                let captionToBeSent = message
                                message = ""
                                Task {
                                    if Checks.isValidCaption(captionToBeSent) {
                                        try await UploadChat.uploadChat(user: user, event: event, caption: captionToBeSent)
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
                .padding(10)
                .background(
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(Color(.gray).opacity(0.3), lineWidth: 1)
                )
                .padding(10)
                
            }
            .onSubmit {
                if Checks.isValidCaption(message)  {
                    let captionToBeSent = message
                    message = ""
                    Task {
                        if Checks.isValidCaption(captionToBeSent) {
                            try await UploadChat.uploadChat(user: user, event: event, caption: captionToBeSent)
                        }
                    }
                }
            }
        }
    }
}
