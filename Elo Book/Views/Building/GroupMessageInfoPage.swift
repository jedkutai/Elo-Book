//
//  GroupMessageInfoPage.swift
//  Elo Book
//
//  Created by Jed Kutai on 1/11/24.
//

import SwiftUI
import Kingfisher

struct GroupMessageInfoPage: View {
    @State var user: User
    @State var receivingUsers: [User]
    @State var thread: Thread
    @Binding var leftGroup: Bool
    @Binding var refresh: Bool
    
    @State private var addUsers = false
    @State private var swipeStarted = false
    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) var colorScheme
    var body: some View {
        NavigationStack {
            VStack {
                // header
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
                
                // body
                ScrollView(.vertical, showsIndicators: false) {
                    
                    if receivingUsers.count < 49 {
                        Button {
                            addUsers.toggle()
                        } label: {
                            HStack {
                                Image(systemName: "plus.app")
                                    .padding(.horizontal)
                                Text("Add to Group")
                            }
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .frame(width: 360, height: 32)
                                .background(colorScheme == .dark ? Theme.textColor : Theme.textColorDarkMode)
                                .foregroundStyle(Color(.systemBlue))
                                .cornerRadius(6)
                                .overlay(RoundedRectangle(cornerRadius: 6)
                                    .stroke(.blue, lineWidth: 1))
                        }
                    }
                    
                    // DisplayUserslist
                    ForEach(receivingUsers, id: \.id) {viewedUser in
                        VStack {
                            
                            NavigationLink {
                                AltUserProfileView(user: user, viewedUser: viewedUser).navigationBarBackButtonHidden()
                            } label: {
                                UserResultCell(user: viewedUser)
                            }
                            
                            Divider()
                                .frame(height: 1)
                        }
                    }
                    
                    if receivingUsers.count > 3 {
                        Button {
                            Task {
                                try await MessageService.leaveGroupChat(user: user, thread: thread)
                                leftGroup.toggle()
                                dismiss()
                            }
                            
                        } label: {
                            Text("LEAVE GROUP")
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .frame(width: 360, height: 32)
                                .background(colorScheme == .dark ? Theme.textColor : Theme.textColorDarkMode)
                                .foregroundStyle(Color(.systemRed))
                                .cornerRadius(6)
                                .overlay(RoundedRectangle(cornerRadius: 6)
                                    .stroke(.gray, lineWidth: 1))
                        }
                    }
                }
            }
            .onAppear {
                Task {
                    receivingUsers = try await FetchService.fetchGroupMessageUsersByThread(thread: thread, user: user)
                }
            }
            .fullScreenCover(isPresented: $addUsers) {
                AddUsersToGroupChatView(user: user, receivingUsers: receivingUsers, thread: thread, refresh: $refresh)
            }
            .onChange(of: refresh) {
                Task {
                    receivingUsers = []
                    receivingUsers = try await FetchService.fetchGroupMessageUsersByThread(thread: thread, user: user)
                    print("refresh group info page")
                }
            }
        }
        .gesture(
            DragGesture()
                .onChanged { value in
                    if value.startLocation.y < 40 {
                        self.swipeStarted = true
                    }
                }
                .onEnded { _ in
                    self.swipeStarted = false
                    dismiss()
                }
        )
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
