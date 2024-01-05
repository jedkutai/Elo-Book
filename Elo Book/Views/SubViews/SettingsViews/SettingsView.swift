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
                    
                    Text("Settings & Privacy")
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
                        
                    } label: {
                        SettingsOption(systemName: "checkmark.seal.fill", text: "Badges")
                    }
                    
                    NavigationLink {
                        SelectFavoriteSportsView(user: user, refresh: $refresh).navigationBarBackButtonHidden()
                    } label: {
                        SettingsOption(systemName: "star", text: "Favorite Sports")
                    }
                    
                    NavigationLink {
                        // notifications
                    } label: {
                        SettingsOption(systemName: "bell", text: "Notifications")
                        Text("not made")
                            .font(.footnote)
                            .foregroundStyle(Color(.systemGray))
                    }
                    
                    NavigationLink {
                        // blocked
                    } label: {
                        SettingsOption(systemName: "circle.slash", text: "Blocked")
                        Text("not made")
                            .font(.footnote)
                            .foregroundStyle(Color(.systemGray))
                    }
                    
                    NavigationLink {
                        // muted
                    } label: {
                        SettingsOption(systemName: "speaker.slash", text: "Muted")
                        Text("not made")
                            .font(.footnote)
                            .foregroundStyle(Color(.systemGray))
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
                            .background(.white)
                            .foregroundStyle(Color(.systemRed))
                            .cornerRadius(6)
                            .overlay(RoundedRectangle(cornerRadius: 6)
                                .stroke(.black, lineWidth: 1))
                            .padding(.top)
                    }
                }
                
            }
            .padding(.horizontal)
        }
        
    }
}
