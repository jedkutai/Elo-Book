//
//  AccountInfoView.swift
//  EloBookv1
//
//  Created by Jed Kutai on 12/28/23.
//

import SwiftUI

struct AccountInfoView: View {
    @Binding var user: User
    
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
                    
                    Text("Account & Privacy")
                        .font(.headline)
                    
                    Spacer()
                }
                
                
                Divider()
                    .frame(height: 1)
                
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
            .padding(.horizontal)
        }
    }
}

