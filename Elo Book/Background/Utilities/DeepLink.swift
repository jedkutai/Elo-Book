//
//  DeepLink.swift
//  EloBookv1
//
//  Created by Jed Kutai on 12/31/23.
//

import Foundation

struct DeepLink {
    // elobook:/viewpost?id=GaPSTNmduumgHaQmxDJS
    
    static let scheme: String = "elobook"
    static let viewPostPath: String = "viewpost"
    static let viewUserPath: String = "viewuser"
    
    static func createPostLink(post: Post) -> String {
        let postId = post.id
        return "\(scheme)://\(viewPostPath)?id=\(postId)"
    }
    
    static func createUserProfileLink(user: User) -> String {
        if let username = user.username {
            return "\(scheme)://\(viewUserPath)?username=\(username)"
        } else {
            return ""
        }
        
    }
    
    
//    static func createPostLink(post: Post) -> String {
//        var components = URLComponents()
//        components.scheme = self.scheme
//        components.host = nil
//        components.path = "/\(self.viewPostPath)"
//        components.queryItems = [URLQueryItem(name: "id", value: post.id)]
//        
//        if let url = components.url {
//            return url.absoluteString
//        } else {
//            return ""
//        }
//    }
//    
//    static func createUserProfileLink(user: User) -> String {
//        if let username = user.username {
//            var components = URLComponents()
//            components.scheme = self.scheme
//            components.host = nil
//            components.path = "/\(self.viewUserPath)"
//            components.queryItems = [URLQueryItem(name: "username", value: username)]
//            
//            if let url = components.url {
//                return url.absoluteString
//            } else {
//                return ""
//            }
//        }
//        return ""
//    }
    
}
