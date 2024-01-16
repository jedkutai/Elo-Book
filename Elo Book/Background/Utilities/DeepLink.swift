//
//  DeepLink.swift
//  EloBookv1
//
//  Created by Jed Kutai on 12/31/23.
//

import Foundation

struct DeepLink {
    
    static let website: String = "https://www.elobook.org"
    
    static let scheme: String = "elobook"
    static let viewPostPath: String = "viewpost"
    static let viewUserPath: String = "viewuser"
    
    static func createPostLink(post: Post) -> String {
        let postId = post.id
        return "\(scheme)://\(viewPostPath)?id=\(postId)"
//        return "\(website)/\(viewPostPath)/\(postId)"
    }
    
    static func createUserProfileLink(user: User) -> String {
        if let username = user.username {
            return "\(scheme)://\(viewUserPath)?username=\(username)"
//            return "\(website)/\(viewUserPath)/\(username)"
        } else {
            return ""
        }
        
    }
    
}
