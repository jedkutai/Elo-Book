//
//  MessageThreadCell.swift
//  Elo Book
//
//  Created by Jed Kutai on 1/12/24.
//

import SwiftUI

struct MessageThreadCell: View {
    @Binding var user: User
    @State var thread: Thread
    
    @State private var threadUser: User? // if there is only one other user, user this
    @State private var threadUsers: [User]? // if theres a few users, user this
    var body: some View {
        NavigationStack {
            Text("Boo")
            if let threadUser = threadUser { // just you and another person
                HStack {
                    // Profile image
                    
                    VStack {
                        // other users fullname, username and badge
                        // text of the last message
                    }
                    
                    // blue indicator if last message hasnt been seen by you
                    // time to show how long ago message was sent
                }
                
            } else if let threadusers = threadUsers {
                
            }
        }
        .onAppear {
            if let memberIds = thread.memberIds { // make sure there are users in the thread
                let otherUsers = memberIds.filter( { $0 != user.id } )
                print(otherUsers)
                if memberIds.count == 2 {
                    
                } else if memberIds.count > 2 {
                    
                }
            }
        }
    }
}
