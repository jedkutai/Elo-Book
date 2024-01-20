//
//  PostNotificationsView.swift
//  Elo Book
//
//  Created by Jed Kutai on 1/20/24.
//

import SwiftUI

struct PostNotificationsView: View {
    @Binding var user: User
    
    private let viewWidth = UIScreen.main.bounds.width * 0.9
    @Environment(\.colorScheme) var colorScheme
    var body: some View {
        NavigationStack {
            LazyVStack {
                Text("Post Notifications")
                    .foregroundStyle(colorScheme == .dark ? Theme.textColorDarkMode : Theme.textColor)
                
                Text("<- Swipe")
                    .foregroundStyle(Color(.systemGray))
                    .font(.footnote)
                
            }
            .frame(width: viewWidth)
            
        }
    }
}

