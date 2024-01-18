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
                    .padding(.horizontal)
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
                    .padding(.horizontal)
                    .foregroundStyle(colorScheme == .dark ? Theme.textColorDarkMode : Theme.textColor)
                    
                    Divider()
                        .frame(height: 1)
                }
            }
            .navigationTitle("Account Info")
            .navigationBarTitleDisplayMode(.inline)
            .padding(.horizontal)
            
        }
    }
}

