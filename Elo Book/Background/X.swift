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
    @Published var email: String = UserDefaults.standard.string(forKey: "email") ?? ""
    @Published var password: String = UserDefaults.standard.string(forKey: "password") ?? ""
    
    // first open stuff
    @Published var firstOpenUserFeed: Bool = true
    @Published var firstOpenUserProfile: Bool = true
    @Published var firstOpenSelectFavorites: Bool = true
    @Published var firstEventSearch: Bool = true
    @Published var events: [Event] = []
    @Published var users: [User] = []
    @Published var teams: [Team] = []
    
    // deep link stuff
    @Published var loadedDeepLink: Bool = false
    @Published var deepLinkType: String = ""
    @Published var deepLinkId: String = ""
    
    
    func clearAll() {
        
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
