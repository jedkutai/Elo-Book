//
//  ReportService.swift
//  Elo Book
//
//  Created by Jed Kutai on 1/18/24.
//

import Foundation
import Firebase

struct ReportService {
    
    static func reportPost(user: User, postUser: User, post: Post, harassment: Bool, violence: Bool, nudity: Bool, scam: Bool, impersonation: Bool, slurs: Bool, other: Bool, additionalComments: String) async throws {
        
        let reportRef = Firestore.firestore().collection("postReports").document()
        
        let report = ReportPost(id: reportRef.documentID, postId: post.id, posterId: postUser.id, reporterId: user.id, harassment: harassment, violence: violence, nudity: nudity, scam: scam, slurs: slurs, impersonation: impersonation, other: other, additionalComments: additionalComments)
        
        guard let encodedReport = try? Firestore.Encoder().encode(report) else { return }
        
        try await reportRef.setData(encodedReport)
        
        try await UserService.unFollowUser(userId: user.id, userToUnfollow: postUser.id)
        try await UserService.unFollowUser(userId: postUser.id, userToUnfollow: user.id)
        
    }
}
