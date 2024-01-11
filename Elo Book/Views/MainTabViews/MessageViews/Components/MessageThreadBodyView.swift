//
//  MessageThreadBodyView.swift
//  Elo Book
//
//  Created by Jed Kutai on 1/11/24.
//

import SwiftUI

struct MessageThreadBodyView: View {
    @Binding var messages: [Message]
    @Binding var user: User
    @State var receivingUser: User
    
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            LazyVStack {
                ForEach(messages, id: \.id) { message in
                    if message.userId == user.id {
                        MessageCell(message: message, messageUser: user, user: user)
                            .rotationEffect(Angle(degrees: 180)).scaleEffect(x: -1.0, y: 1.0, anchor: .center)
                    } else {
                        MessageCell(message: message, messageUser: receivingUser, user: user)
                            .rotationEffect(Angle(degrees: 180)).scaleEffect(x: -1.0, y: 1.0, anchor: .center)
                    }
                    
                }
                .padding(.horizontal, 10)
                
            }
        }
        .rotationEffect(Angle(degrees: 180)).scaleEffect(x: -1.0, y: 1.0, anchor: .center)
        .onTapGesture {
            hideKeyboard()
        }
        .scrollDismissesKeyboard(.interactively)
    }
}
