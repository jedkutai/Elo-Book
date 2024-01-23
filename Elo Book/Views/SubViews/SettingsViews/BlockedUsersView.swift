//
//  BlockedUsersView.swift
//  Elo Book
//
//  Created by Jed Kutai on 1/23/24.
//

import SwiftUI

struct BlockedUsersView: View {
    @State var user: User
    
    @EnvironmentObject var x: X
    var body: some View {
        NavigationStack {
            VStack {
                ScrollView(.vertical, showsIndicators: false) {
                    ForEach(x.blocked, id: \.id) { block in
                        BlockedUserCell(user: user, blockedUserId: block.userToBlockId)
                    }
                }
                .refreshable {
                    Task {
                        x.blocked = try await FetchService.fectchBlocksViaUserId(userId: user.id)
                    }
                }
            }
            .navigationTitle("Blocked Users")
            .navigationBarTitleDisplayMode(.inline)
            
        }
    }
}


