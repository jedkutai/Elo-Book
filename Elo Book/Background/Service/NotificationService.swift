//
//  NotificationService.swift
//  Elo Book
//
//  Created by Jed Kutai on 1/10/24.
//

import Foundation
import Firebase
import FirebaseFirestore
import FirebaseMessaging

struct NotificationService {
    static let notificationTitle: String = "Elo Book"
    
    static func likedPostPayLoad(username: String, fcmToken: String, postId: String) -> [String: Any] {
        
        let notificationPayload: [String: Any] = [
            "to": fcmToken,
            "notification": [
                "title": self.notificationTitle,
                "body": "\(username) liked your post."
            ],
            "data": [
                "post": postId
            ]
        ]
        
        return notificationPayload
    }
    
    static func likedPost (user: User, postUser: User, post: Post) async throws {
        
        // get postUsers fcm token
        // go to postuser's settings and see if they allow likedpost notifications
        // if the do, user likedPostpayload to create the json
        
    }
    
    
}
