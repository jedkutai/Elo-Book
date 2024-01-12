//
//  MessageViewHeader.swift
//  Elo Book
//
//  Created by Jed Kutai on 1/12/24.
//

import SwiftUI

struct MessageViewHeader: View {
    @Binding var user: User
    @Binding var showCreateNewMessage: Bool
    @Environment(\.colorScheme) var colorScheme
    var body: some View {
        HStack {
            
            SquareProfilePicture(user: user, size: .shmedium)
            
            Text("MESSAGES")
                .fontWeight(.bold)
                .foregroundStyle(colorScheme == .dark ? Theme.textColorDarkMode : Theme.textColor)
            
            Spacer()
            
            Button {
                showCreateNewMessage.toggle()
            } label: {
                Image(systemName: "square.and.pencil")
                    .foregroundStyle(colorScheme == .dark ? Theme.buttonColorDarkMode : Theme.buttonColor)
            }
            
        }
        .padding(.horizontal)
        .padding(.top)
    }
}
