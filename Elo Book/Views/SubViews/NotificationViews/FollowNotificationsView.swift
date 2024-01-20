//
//  FollowNotificationsView.swift
//  Elo Book
//
//  Created by Jed Kutai on 1/20/24.
//

import SwiftUI

struct FollowNotificationsView: View {
    @Binding var user: User
    
    private let viewWidth = UIScreen.main.bounds.width * 0.9
    @Environment(\.colorScheme) var colorScheme
    var body: some View {
        NavigationStack {
            LazyVStack {
                Text("Follow Notifications")
                    .foregroundStyle(colorScheme == .dark ? Theme.textColorDarkMode : Theme.textColor)
                
                Text("Swipe ->")
                    .foregroundStyle(Color(.systemGray))
                    .font(.footnote)
                
            }
            .frame(width: viewWidth)
            
        }
    }
}
