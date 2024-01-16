//
//  SettingsView.swift
//  EloBookv1
//
//  Created by Jed Kutai on 12/25/23.
//

import SwiftUI

struct SettingsView: View {
    @State var user: User
    
    @Binding var refresh: Bool
    
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
                    
                    Spacer()
                    
                    Text("Settings")
                        .font(.headline)
                    
                    Spacer()
                    
                }
                
                Divider()
                    .frame(height: 1)
                
                
                ScrollView {
                    NavigationLink {
                        AccountInfoView(user: $user).navigationBarBackButtonHidden()
                    } label: {
                        SettingsOption(systemName: "lock", text: "Account Info")
                    }
                    
                    NavigationLink {
                        SelectBadgesView(user: user, refresh: $refresh).navigationBarBackButtonHidden()
                    } label: {
                        SettingsOption(systemName: "checkmark.seal.fill", text: "Badges")
                    }
                    
                    NavigationLink {
                        SelectFavoriteSportsView(user: user, refresh: $refresh).navigationBarBackButtonHidden()
                    } label: {
                        SettingsOption(systemName: "star", text: "Favorite Sports")
                    }
                    
                    NavigationLink {
                        NotificationsSettingsView(user: user, refresh: $refresh).navigationBarBackButtonHidden()
                    } label: {
                        SettingsOption(systemName: "bell", text: "Notifications")
                    }
                    
                    NavigationLink {
                        FirstOpenView().navigationBarBackButtonHidden()
                    } label: {
                        HStack {
                            Spacer()
                            Text("Logout")
                            Spacer()
                        }
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .frame(height: 32)
                            .background(colorScheme == .dark ? Theme.buttonColor : Theme.buttonColorDarkMode)
                            .foregroundStyle(Color(.systemRed))
                            .cornerRadius(6)
                            .overlay(RoundedRectangle(cornerRadius: 6)
                                .stroke(colorScheme == .dark ? Theme.buttonColorDarkMode : Theme.buttonColor, lineWidth: 1))
                            .padding(.top)
                    }
                }
                
            }
            .padding(.horizontal)
            .gesture(
                DragGesture()
                    .onChanged { value in
                        if value.startLocation.y < 20 {
                            self.swipeStarted = true
                        }
                    }
                    .onEnded { _ in
                        self.swipeStarted = false
                        dismiss()
                    }
            )
        }
        
    }
}
