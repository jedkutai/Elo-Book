//
//  PostCellExpandedComments.swift
//  EloBookv1
//
//  Created by Jed Kutai on 12/24/23.
//

import SwiftUI

struct PostCellExpandedComments: View {
    @Binding var user: User
    @Binding var comments: [Comment]
    
    var body: some View {
        NavigationStack {
            LazyVStack {
                ForEach(comments, id: \.id) { comment in
                    CommentCell(user: user, comment: comment)
                }
                
            }
            
        }
    }
}
