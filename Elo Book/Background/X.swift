//
//  X.swift
//  Elo Book
//
//  Created by Jed Kutai on 1/4/24.
//

import SwiftUI
import Combine
import CoreLocation

@MainActor
class X: ObservableObject {
    
    // login stuff
    @Published var uid: String = UserDefaults.standard.string(forKey: "uid") ?? ""
    
    // first open stuff
    @Published var firstOpenUserFeed: Bool = true
    @Published var firstOpenUserProfile: Bool = true
    @Published var firstOpenSelectFavorites: Bool = true
    @Published var firstEventSearch: Bool = true
    @Published var events: [Event] = []
    @Published var users: [User] = []
    @Published var teams: [Team] = []
    
    @Published var blocked: [Block] = []
    @Published var blockedBy: [Block] = []
    
    // for notifications
    @Published var recentFollows: [Follow] = [] // load 20 most recent FetchService.fetchRecentFollowsByUser()
    @Published var recentComments: [CommentOnPostAlert] = []
    @Published var recentReplies: [ReplyOnCommentAlert] = []
    
    @Published var unseenFollows = false
    @Published var unseenComments = false
    @Published var unseenReplies = false
    
    @Published var unseenNotifications = false
    
    // deep link stuff
    @Published var loadedDeepLink: Bool = false
    @Published var deepLinkType: String = ""
    @Published var deepLinkId: String = ""
    
    // tab view controller
    @Published var selectedTab: Tab = .home
    
    func setUnseenNotifications() {
        let status = self.unseenFollows || self.unseenComments || self.unseenReplies
        self.unseenNotifications = status
    }
    
    func clearAll() {
        
        UserDefaults.standard.removeObject(forKey: "uid")
        // first open stuff
        self.firstOpenUserFeed = true
        self.firstOpenUserProfile = true
        self.firstOpenSelectFavorites = true
        self.firstEventSearch = true
        self.events = []
//        self.users = []
        self.teams = []
        
        // deep link stuff
        self.loadedDeepLink = false
        self.deepLinkType = ""
        self.deepLinkId = ""
    }
    
    func mergeArraysAndRemoveDuplicates<T: Hashable, K: Hashable>(_ array1: [T], _ array2: [T], keyPath: KeyPath<T, K>) -> [T] {
        var mergedArray = array1 + array2
        mergedArray = mergedArray.reduce(into: [T]()) { (result, object) in
            if !result.contains(where: { $0[keyPath: keyPath] == object[keyPath: keyPath] }) {
                result.append(object)
            }
        }
        return mergedArray
    }
    
    func handleDeepLink(url: URL) {
        if let components = URLComponents(url: url, resolvingAgainstBaseURL: false) {
            if let queryItems = components.queryItems {
                for queryItem in queryItems {
                    let type = queryItem.name
                    if let value = queryItem.value {
                        if type == "id" {
                            deepLinkType = "viewPost"
                            deepLinkId = value
                            loadedDeepLink = true
                        } else if type == "username" {
                            deepLinkType = "viewUser"
                            deepLinkId = value
                            loadedDeepLink = true
                        }
                    }
                    
                }
            }
        }
        
    }
}
