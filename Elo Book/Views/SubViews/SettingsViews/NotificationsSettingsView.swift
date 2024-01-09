//
//  NotificationsSettingsView.swift
//  Elo Book
//
//  Created by Jed Kutai on 1/8/24.
//

import SwiftUI

struct NotificationsSettingsView: View {
    @State var user: User
    @Binding var refresh: Bool
    
    @State private var userFollowedYou = true
    @State private var userLikedYourPost = true
    @State private var userCommentedOnYourPost = true
    @State private var userLikedYourComment = true
    @State private var communityNotificationsAllowed = true
    
    @State private var swipeStarted = false
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
                            .foregroundColor(colorScheme == .dark ? Theme.buttonColorDarkMode : Theme.buttonColor)
                        
                    }
                    Text("Back")
                        .foregroundColor(Color.clear) // invisible
                    
                    Spacer()
                    
                    Text("Notifications")
                        .font(.headline)
                    
                    Spacer()
                    
                    if false {
                        Button {
                            dismiss()
                            Task {
                                
                            }
                            refresh.toggle()
                        } label: {
                            Text("Update")
                                .foregroundStyle(Color(.systemBlue))
                        }
                    } else {
                        Text("Update")
                            .foregroundStyle(Color(.systemGray))
                    }
                }
                .padding(.horizontal)
                
                
                Divider()
                    .frame(height: 1)
                
                ScrollView {
                    
                }
                
            }
        }
    }
}

