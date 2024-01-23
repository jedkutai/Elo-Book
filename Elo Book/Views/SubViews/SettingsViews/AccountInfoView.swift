//
//  AccountInfoView.swift
//  EloBookv1
//
//  Created by Jed Kutai on 12/28/23.
//

import SwiftUI

struct AccountInfoView: View {
    @Binding var user: User
    
    @State private var swipeStarted = false
    @Environment(\.colorScheme) var colorScheme
    var body: some View {
        NavigationStack {
            VStack {
                
                ScrollView {
                    HStack {
                        Image(systemName: "envelope")
                            .foregroundColor(Color(.systemGray))
                        
                        Text("Email: ")
                            .fontWeight(.semibold)
                        
                        Text("\(user.email)")
                        
                        Spacer()
                        
                    }
                    .foregroundStyle(colorScheme == .dark ? Theme.textColorDarkMode : Theme.textColor)
                    
                    Divider()
                        .frame(height: 1)
                    
                    HStack {
                        Image(systemName: "person.crop.circle.badge.checkmark")
                            .foregroundColor(Color(.systemGray))
                        
                        Text("Created: ")
                            .fontWeight(.semibold)
                        
                        Text("\(DateFormatter.longDate(timestamp: user.timestamp))")
                        
                        Spacer()
                        
                    }
                    .foregroundStyle(colorScheme == .dark ? Theme.textColorDarkMode : Theme.textColor)
                    
                    Divider()
                        .frame(height: 1)
                    
                    if let username = user.username {
                        HStack {
                            Image(systemName: "textformat.abc.dottedunderline")
                                .foregroundColor(Color(.systemGray))
                            
                            Text("Username: ")
                                .fontWeight(.semibold)
                            
                            Text("\(username)")
                            
                            Spacer()
                            
                        }
                        .foregroundStyle(colorScheme == .dark ? Theme.textColorDarkMode : Theme.textColor)
                        
                        Divider()
                            .frame(height: 1)
                        
                        Text("Changing usernames is currently disabled. It will be on the app in the near future, I just want to make everyone that chose a horrible username to be stuck with it for a little.")
                            .padding(.vertical)
                            .font(.footnote)
                            .foregroundStyle(Color(.systemGray))
                            .multilineTextAlignment(.center)
                    }
                }
                NavigationLink {
                    DeleteAccountView(user: user)
                } label: {
                    Text("Contact Us")
                        .font(.footnote)
                        .foregroundStyle(Color(.systemBlue))
                }
                
                Text("Hey it's me again. Normally an option to delete your account is down here. I am a bit lazy and haven't built that yet so you need to go fill out the contact us form on our website and request a manual deletion that I probably won't read because I'm the worst.")
                    .font(.footnote)
                    .foregroundStyle(Color(.systemGray))
                    .multilineTextAlignment(.center)
            }
            .navigationTitle("Account Info")
            .navigationBarTitleDisplayMode(.inline)
            .padding(.horizontal)
            
        }
    }
}

