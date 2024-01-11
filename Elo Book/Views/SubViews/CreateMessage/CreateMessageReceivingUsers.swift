//
//  CreateMessageReceivingUsers.swift
//  Elo Book
//
//  Created by Jed Kutai on 1/10/24.
//

import SwiftUI

struct CreateMessageReceivingUsers: View {
    @Binding var recievingUsers: [User]
    
    @Environment(\.colorScheme) var colorScheme
    var body: some View {
        if !recievingUsers.isEmpty {
            HStack {
                Text("To:")
                    .padding(.horizontal, 5)
                    .foregroundStyle(colorScheme == .dark ? Theme.textColorDarkMode : Theme.textColor)
                    .font(.footnote)
                    .fontWeight(.bold)
                
                
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack {
                        ForEach(Array(recievingUsers.enumerated()), id: \.0) { index, user in
                            Button {
                                recievingUsers.remove(at: index)
                            } label: {
                                CreateMessageUserCell(user: user)
                                    .padding(5)
                                    .background(
                                        RoundedRectangle(cornerRadius: 2.5)
                                            .stroke(Color(.systemBlue), lineWidth: 1)
                                    )
                            }
                        }
                    }
                }
                .frame(height: 30)
                
                Spacer()
                
            }
            .padding(.horizontal)
        }
    }
}
