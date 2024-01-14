//
//  ThreadView.swift
//  Elo Book
//
//  Created by Jed Kutai on 1/13/24.
//

import SwiftUI

struct ThreadView: View {
    @State var user: User
    @State var thread: Thread
    @StateObject var messagesManager: MessageManager
    
    @State private var threadUser: User? // if there is only one other user, user this
    @State private var threadUsers: [User]? // if theres a few users, user this
    
    @State private var swipeStarted = false
    
    @Environment(\.dismiss) var dismiss
    @Environment(\.colorScheme) var colorScheme
    
    
    init(user: User, thread: Thread) { // need this to initialize messagesmanager
        self._user = State(initialValue: user)
        self._thread = State(initialValue: thread)
        self._messagesManager = StateObject(wrappedValue: MessageManager(thread: thread, user: user))
    }
    
    var body: some View {
        NavigationStack {
            Group {
                if let threadUser = threadUser { // just you and another person
                    ThreadViewSingle(user: user, threadUser: threadUser, thread: thread, messagesManager: messagesManager, dismiss: dismiss)
                } else if let threadUsers = threadUsers { // group chat with the fellas
                    ThreadViewGroup(user: user, threadUsers: threadUsers, thread: thread, messagesManager: messagesManager, dismiss: dismiss)
                } else {
                    Image(systemName: "circle.fill")
                        .foregroundStyle(Color(.clear))
                }
            }
            .padding(.horizontal, 10)
        }
        .onAppear {
            Task {
                if let memberIds = thread.memberIds { // make sure there are users in the thread
                    let otherUserIds = memberIds.filter( { $0 != user.id } )
                    if otherUserIds.count == 1 {
                        threadUser = try await FetchService.fetchUserById(withUid: otherUserIds[0])
                    } else if memberIds.count > 2 {
                        threadUsers = try await FetchService.fetchUsersByUserIds(userIds: otherUserIds)
                    }
                }
            }
        }
//        .gesture(
//            DragGesture()
//                .onChanged { value in
//                    if value.startLocation.y < 40 {
//                        self.swipeStarted = true
//                    }
//                }
//                .onEnded { _ in
//                    self.swipeStarted = false
//                    dismiss()
//                }
//        )
    }

}
