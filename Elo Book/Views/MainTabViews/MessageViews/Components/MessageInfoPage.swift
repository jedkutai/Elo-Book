//
//  MessageInfoPage.swift
//  Elo Book
//
//  Created by Jed Kutai on 1/11/24.
//

import SwiftUI

struct MessageInfoPage: View {
    @State var user: User
    @State var viewedUser: User
    
    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) var colorScheme
    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "chevron.left")
                            .foregroundStyle(colorScheme == .dark ? Theme.textColorDarkMode : Theme.textColor)
                    }
                    
                    Spacer()
                    if let username = viewedUser.username {
                        Text("\(username)")
                            .foregroundStyle(colorScheme == .dark ? Theme.textColorDarkMode : Theme.textColor)
                    }
                    
                    if let displayedBadge = viewedUser.displayedBadge {
                        BadgeDiplayer(badge: displayedBadge)
                    }
                    
                    Spacer()
                    
                    Image(systemName: "chevron.left")
                        .foregroundStyle(Color.clear)
                }
                .padding()
                
                AltProfileHeader(user: $user, viewedUser: $viewedUser)
                
                NavigationLink {
                    AltUserProfileView(user: user, viewedUser: viewedUser).navigationBarBackButtonHidden()
                } label: {
                    Text("View Page")
                        .foregroundStyle(Color(.systemBlue))
                        .padding()
                }
                
                Spacer()
            }
        }
    }
}
