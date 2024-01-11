//
//  SharedUserMessageBubble.swift
//  Elo Book
//
//  Created by Jed Kutai on 1/11/24.
//

import SwiftUI

struct SharedUserMessageBubble: View {
    @Binding var message: Message
    @Binding var messageUser: User
    @Binding var user: User
    
    @State private var sharedUser: User?
    var body: some View {
        
        VStack {
            if let loadedUser = sharedUser {
                NavigationLink {
                    AltUserProfileView(user: user, viewedUser: loadedUser).navigationBarBackButtonHidden()
                } label: {
                    if user.id == messageUser.id {
                        HStack {
                            Spacer()
                            StaticProfileHeaderBlue(viewedUser: loadedUser)
                        }
                    } else {
                        HStack {
                            StaticProfileHeader(viewedUser: loadedUser)
                            Spacer()
                        }
                        
                    }
                }
            }
            if !message.caption.isEmpty {
                StandardMessageBubble(message: $message, messageUser: $messageUser, user: $user)
            }
        }
        .onAppear {
            Task {
                sharedUser = try await FetchService.fetchUserById(withUid: message.shareId)
            }
        }
    }
}
