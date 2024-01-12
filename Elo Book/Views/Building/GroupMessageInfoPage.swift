//
//  GroupMessageInfoPageHeader.swift
//  Elo Book
//
//  Created by Jed Kutai on 1/11/24.
//

import SwiftUI
import Kingfisher

struct GroupMessageInfoPageHeader: View {
    @State var user: User
    @State var receivingUsers: [User]
    @State var thread: Thread
    @Binding var leftGroup: Bool
    
    @State private var addUsers = false
    
    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) var colorScheme
    var body: some View {
        NavigationStack {
            VStack {
                HStack { // info page header
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "chevron.left")
                            .foregroundStyle(colorScheme == .dark ? Theme.textColorDarkMode : Theme.textColor)
                    }
                    
                    Spacer()
                    
                    
                    VStack {
                        if let imageUrl = thread.imageUrl {
                            
                            KFImage(URL(string: imageUrl))
                                .resizable()
                                .scaledToFit()
                                .frame(width: 40, height: 40)
                                .clipShape(RoundedRectangle(cornerRadius: 5))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 5)
                                        .stroke(colorScheme == .dark ? Theme.textColorDarkMode : Theme.textColor, lineWidth: 5 * 0.3)
                                )
                        } else {
                            Image(systemName: "person.3")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 40, height: 40)
                                .foregroundColor(Color(.systemGray4))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 5)
                                        .stroke(colorScheme == .dark ? Theme.textColorDarkMode : Theme.textColor, lineWidth: 5 * 0.3)
                                )
                        }
                        
                        if let threadName = thread.threadName {
                            //
                            Text("\(threadName)")
                                .font(.footnote)
                                .fontWeight(.bold)
                                .foregroundStyle(colorScheme == .dark ? Theme.textColorDarkMode : Theme.textColor)
                        } else {
                            let usernames = self.getGroupChatTitle(threadUsers: receivingUsers)
                            
                            Text("\(usernames)")
                                .font(.footnote)
                                .fontWeight(.bold)
                                .foregroundStyle(colorScheme == .dark ? Theme.textColorDarkMode : Theme.textColor)
                        }
                        
                        
                    }
                    
                    Spacer()
                    
                    
                }
                .frame(height: 40)
                .padding()
                
                Divider()
                    .frame(height: 1)
                
                ScrollView(.vertical, showsIndicators: false) {
                    
                }
            }
        }
    }
    
    private func getGroupChatTitle(threadUsers: [User]) -> String {
        var usernamesArray: [String] = []
        
        for user in threadUsers {
            if let username = user.username {
                usernamesArray.append(username)
            }
        }
        
        usernamesArray = usernamesArray.sorted()
        let usernames = usernamesArray.joined(separator: ", ")
        
        return usernames
    }
}
