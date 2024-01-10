//
//  NotificationSettings.swift
//  Elo Book
//
//  Created by Jed Kutai on 1/9/24.
//

struct UserNotificationSettings: Identifiable, Hashable, Codable {
    let id: String
    var followAlerts: Bool?
    var likedPostAlerts: Bool?
    var commentedPostAlerts: Bool?
    var likedCommentAlerts: Bool?
    var communityInviteAlerts: Bool?
    var communityMessageAlerts: Bool?
}



