//
//  GroupMessageThreadViewHeader.swift
//  Elo Book
//
//  Created by Jed Kutai on 1/11/24.
//

import SwiftUI
import Kingfisher

struct GroupMessageThreadViewHeader: View {
    @Binding var thread: Thread
    @Binding var user: User
    @State var receivingUsers: [User]
    @Binding var leftGroup: Bool
    @Binding var refresh: Bool
    
    var dismiss: DismissAction
    @Environment(\.colorScheme) var colorScheme
    var body: some View {
        HStack { // profile page header
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
            
            NavigationLink {
                GroupMessageInfoPage(user: user, receivingUsers: receivingUsers, thread: thread, leftGroup: $leftGroup, refresh: $refresh).navigationBarBackButtonHidden()
            } label: {
                Image(systemName: "info.circle")
                    .foregroundStyle(colorScheme == .dark ? Theme.textColorDarkMode : Theme.textColor)
            }
            
        }
        .frame(height: 40)
        .padding()
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


