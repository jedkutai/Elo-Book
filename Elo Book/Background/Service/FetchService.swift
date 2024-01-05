//
//  FetchService.swift
//  Elo
//
//  Created by Jed Kutai on 12/16/23.
//

import Foundation
import Firebase
import FirebaseFirestore

struct FetchService {
    static func fetchEmptyFeedUsers(user: User) async throws -> [User] {
        var returnedUsers: [User] = []
        
        let query = Firestore.firestore().collection("users")
            .order(by: "score", descending: true)
            .limit(to: 11)
        
        let snapshot = try await query.getDocuments()
        let users = snapshot.documents.compactMap({ try? $0.data(as: User.self) })
        
        for newUser in users {
            if newUser.id != user.id {
                returnedUsers.append(newUser)
            }
        }
        
        returnedUsers.shuffle()
        return returnedUsers
    }
    
    static func fetchCommentLikesByCommentId(comment: Comment) async throws -> [CommentLike] {
        let query = Firestore.firestore().collection("posts").document(comment.postId).collection("comments").document(comment.id).collection("commentLikes")
            
        
        let snapshot = try await query.getDocuments()
        let commentLikes = snapshot.documents.compactMap({ try? $0.data(as: CommentLike.self) })
        
        return commentLikes
    } 
    
    static func fetchCommentUsersByComments(comments: [Comment]) async throws -> [User] {
        var users: [User] = []
        for comment in comments {
            if !users.contains(where: {$0.id == comment.userId }) {
                let userEntry = try await fetchUserById(withUid: comment.userId)
                users.append(userEntry)
            }
        }
        return users
    }
    
    
    static func fetchUserByUsername(username: String) async throws -> User {
        let query = Firestore.firestore().collection("users")
            .whereField("username", isEqualTo: username)
            .limit(to: 1)
        
        let snapshot = try await query.getDocuments()
        
        let users = snapshot.documents.compactMap({ try? $0.data(as: User.self) })
        
        return users[0]
    }
    
    static func fetchTeamById(docId: String) async throws -> Team {
        let docRef = Firestore.firestore().collection("teams").document(docId)
        let document = try await docRef.getDocument()
        let team = try document.data(as: Team.self)
        return team
    }
    
    static func fetchRecentEvents() async throws -> [Event] {
        var events: [Event] = []
        
        let threeDaysAgoDate = Calendar.current.date(byAdding: .day, value: -2, to: Date())!
        let tenDaysFromNowDate = Calendar.current.date(byAdding: .day, value: 8, to: Date())!
        
        let threeDaysAgo = Timestamp(date: threeDaysAgoDate)
        let tenDaysFromNow = Timestamp(date: tenDaysFromNowDate)

        let query = Firestore.firestore()
            .collection("events")
            .whereField("timestamp", isGreaterThanOrEqualTo: threeDaysAgo)
            .whereField("timestamp", isLessThanOrEqualTo: tenDaysFromNow)
        
        let snapshot = try await query.getDocuments()
        events = snapshot.documents.compactMap({ try? $0.data(as: Event.self) })
        return events
    }
    
    static func fetchPostByPostId(postId: String) async throws -> Post {
        let query = Firestore.firestore().collection("posts")
            .whereField("id", isEqualTo: postId)
            .limit(to: 1)
        
        let snapshot = try await query.getDocuments()
        
        let posts = snapshot.documents.compactMap({ try? $0.data(as: Post.self) })
        
        return posts[0]
    }
    
    
    static func fetchUserFavorites(user: User) async throws -> [Event] {
        var events: [Event] = []
        
        let currentTime = Timestamp(date: Date())
        
        if let favoriteSports = user.favorites {
            
            let query2 = Firestore.firestore()
                .collection("events")
                .whereField("sport", in: favoriteSports)
                .whereField("timestamp", isGreaterThan: currentTime)
                .order(by: "timestamp")
                .limit(to: 20)
            
            
            let snapshot2 = try await query2.getDocuments()
            events = snapshot2.documents.compactMap({ try? $0.data(as: Event.self) })
        }
        
        var uniqueEvents: [Event] = []
        
        for event in events {
            if !uniqueEvents.contains(where: { $0.id == event.id }) {
                uniqueEvents.append(event)
            }
        }
        
        events = uniqueEvents
        
        if events.count < 20 {
            let query4 = Firestore.firestore()
                .collection("events")
                .whereField("timestamp", isGreaterThan: currentTime)
                .order(by: "timestamp")
                .limit(to: 20 - events.count)
            
            let snapshot4 = try await query4.getDocuments()
            
            let events4 = snapshot4.documents.compactMap({ try? $0.data(as: Event.self) })
            events += events4
        }
        
        uniqueEvents = []
        
        for event in events {
            if !uniqueEvents.contains(where: { $0.id == event.id }) {
                uniqueEvents.append(event)
            }
        }
        
        events = uniqueEvents
        
        events.sort { $0.timestamp.dateValue() < $1.timestamp.dateValue() }
        return Array(events.prefix(20))
    }
    
    
    
    
    static func fetchCommentsByPostId(postId: String) async throws -> [Comment] {
        
        let query = Firestore.firestore().collection("posts").document(postId).collection("comments")
            .order(by: "score", descending: true)
            .limit(to: 20)
            
        let snapshot = try await query.getDocuments()
        let comments = snapshot.documents.compactMap({ try? $0.data(as: Comment.self) })
        
        return comments
    }
    
    
    
    static func fetchEventsByEventIds(eventIds: [String]) async throws -> [Event] {
        var events: [Event] = []
        
        for id in eventIds {
            let query = Firestore.firestore()
                .collection("events")
                .whereField("id", isEqualTo: id)
            
            let snapshot = try await query.getDocuments()
            events += snapshot.documents.compactMap({ try? $0.data(as: Event.self) })
        }
        
        return events
    }
    
    static func fetchEventPostsByScore(event: Event) async throws -> [Post] {
        let query = Firestore.firestore()
            .collection("posts")
            .whereField("eventIds", arrayContains: event.id)
            .order(by: "score", descending: true)
            .limit(to: 20)
        
        let snapshot = try await query.getDocuments()
        let posts = snapshot.documents.compactMap({ try? $0.data(as: Post.self) })
        
        return posts
    }
    
    static func fetchMoreEventPostsByScore(event: Event, limit: Int) async throws -> [Post] {
        let query = Firestore.firestore()
            .collection("posts")
            .whereField("eventIds", arrayContains: event.id)
            .order(by: "score", descending: true)
            .limit(to: limit)
        
        let snapshot = try await query.getDocuments()
        let posts = snapshot.documents.compactMap({ try? $0.data(as: Post.self) })
        
        return posts
    }
    
    static func fetchEventPostsByTime(event: Event) async throws -> [Post] {
        let query = Firestore.firestore()
            .collection("posts")
            .whereField("eventIds", arrayContains: event.id)
            .order(by: "timestamp", descending: true)
            .limit(to: 20)
        
        let snapshot = try await query.getDocuments()
        let posts = snapshot.documents.compactMap({ try? $0.data(as: Post.self) })
        
        return posts
    }
    
    static func fetchMoreEventPostsByTime(event: Event, lastPost: Post?) async throws -> [Post] {
        var posts: [Post] = []
        if let post = lastPost {
            let query = Firestore.firestore()
                .collection("posts")
                .whereField("eventIds", arrayContains: event.id)
                .whereField("timestamp", isLessThan: post.timestamp)
                .order(by: "timestamp", descending: true)
                .limit(to: 20)
            
            let snapshot = try await query.getDocuments()
            posts = snapshot.documents.compactMap({ try? $0.data(as: Post.self) })
        } else {
            posts = try await fetchEventPostsByTime(event: event)
        }
        
        return posts
    }
    
    static func fetchPostLikesByPostId(postId: String) async throws -> [PostLike] {
        let query = Firestore.firestore().collection("posts").document(postId).collection("likes")
        
        let snapshot = try await query.getDocuments()
        let likes = snapshot.documents.compactMap({ try? $0.data(as: PostLike.self) })
        
        return likes
    }
    
    static func fetchUsersByPosts(posts: [Post]) async throws -> [User] {
        var users: [User] = []
        for post in posts {
            if !users.contains(where: { $0.id == post.userId}) {
                let userEntry = try await fetchUserById(withUid: post.userId)
                users.append(userEntry)
            }
        }
        return users
    }
    
    static func fetchUsersByUserIds(userIds: [String]) async throws -> [User] {
        var users: [User] = []
        
        let query = Firestore.firestore().collection("users")
            .whereField("id", in: userIds)
        
        let snapshot = try await query.getDocuments()
        users = snapshot.documents.compactMap({ try? $0.data(as: User.self) })
        return users
    }
    
    static func fetchFeedPostsByFollowing(uid: String, following: [Follow]) async throws -> [Post] {
        let uids = following.map { $0.followingId }
        
        let query = Firestore.firestore()
            .collection("posts")
            .whereField("userId", in: uids + [uid])
            .order(by: "timestamp", descending: true)
            .limit(to: 20)
        
        let snapshot = try await query.getDocuments()
        let posts = snapshot.documents.compactMap({ try? $0.data(as: Post.self) })

        return posts
    }
    
    static func fetchMutedUsersByUserId(userId: String) async throws -> [User] {
        let snapshot = try await Firestore.firestore().collection("users").document(userId).collection("muted").getDocuments()
        
        let mutedUsers = snapshot.documents.compactMap({ try? $0.data(as: User.self) })
        
        return mutedUsers
    }
    
    static func fetchFeedPostsByUser(user: User) async throws -> [Post] {
        var posts: [Post] = []
        
        let following = try await self.fetchFollowingByUserId(userId: user.id)
        let mutedUsers = try await self.fetchMutedUsersByUserId(userId: user.id)
        
        var uids = following.map { $0.followingId }
        uids += [user.id]
        let mutedIds = mutedUsers.map { $0.id }
        
        if mutedIds.isEmpty {
            let query = Firestore.firestore()
                .collection("posts")
                .whereField("userId", in: uids)
                .order(by: "timestamp", descending: true)
                .limit(to: 20)
            
            let snapshot = try await query.getDocuments()
            posts = snapshot.documents.compactMap({ try? $0.data(as: Post.self) })
        } else {
            let query = Firestore.firestore()
                .collection("posts")
                .whereField("userId", in: uids)
                .whereField("userId", notIn: mutedIds)
                .order(by: "timestamp", descending: true)
                .limit(to: 20)
            
            let snapshot = try await query.getDocuments()
            posts = snapshot.documents.compactMap({ try? $0.data(as: Post.self) })
        }

        return posts
    }
    
    static func fetchMoreFeedPostsByUser(user: User, userFeedPosts: [Post]) async throws -> [Post] {
        var posts: [Post] = userFeedPosts
        
        if let lastPost = posts.last {
            let following = try await self.fetchFollowingByUserId(userId: user.id)
            let mutedUsers = try await self.fetchMutedUsersByUserId(userId: user.id)
            
            var uids = following.map { $0.followingId }
            uids += [user.id]
            let mutedIds = mutedUsers.map { $0.id }
            
            if mutedIds.isEmpty {
                let query = Firestore.firestore()
                    .collection("posts")
                    .whereField("timestamp", isLessThan: lastPost.timestamp)
                    .whereField("userId", in: uids)
                    .order(by: "timestamp", descending: true)
                    .limit(to: 20)
                
                let snapshot = try await query.getDocuments()
                posts += snapshot.documents.compactMap({ try? $0.data(as: Post.self) })
            } else {
                let query = Firestore.firestore()
                    .collection("posts")
                    .whereField("timestamp", isLessThan: lastPost.timestamp)
                    .whereField("userId", in: uids)
                    .whereField("userId", notIn: mutedIds)
                    .order(by: "timestamp", descending: true)
                    .limit(to: 20)
                
                let snapshot = try await query.getDocuments()
                posts += snapshot.documents.compactMap({ try? $0.data(as: Post.self) })
            }
        } else {
            posts = try await self.fetchFeedPostsByUser(user: user)
        }
        return posts
    }
    
    static func fetchMoreFeedPostsByFollowing(uid: String, following: [Follow], lastPost: Post?) async throws -> [Post] {
        var posts: [Post] = []
        
        if let post = lastPost {
            let uids = following.map { $0.followingId }
            
            let query = Firestore.firestore()
                .collection("posts")
                .whereField("userId", in: uids + [uid])
                .whereField("timestamp", isLessThan: post.timestamp)
                .order(by: "timestamp", descending: true)
                .limit(to: 20)
            
            let snapshot = try await query.getDocuments()
            posts = snapshot.documents.compactMap({ try? $0.data(as: Post.self) })

        } else {
            posts = try await fetchFeedPostsByFollowing(uid: uid, following: following)
        }
        return posts
    }
    
    
    static func fetchTeamsBySport(sport: String) async throws -> [Team] {
        let query = Firestore.firestore()
            .collection("teams")
            .whereField("sport", isEqualTo: sport.lowercased())
        
        let snapshot = try await query.getDocuments()
        var teams = snapshot.documents.compactMap({ try? $0.data(as: Team.self) })
        
        teams.sort { (team1, team2) -> Bool in
            return team1.teamName < team2.teamName
        }
        
        return teams
    }
    
    static func fetchUserById(withUid uid: String) async throws -> User {
        let snapshot = try await Firestore.firestore().collection("users").document(uid).getDocument()
        return try snapshot.data(as: User.self)
    }
    
    static func fetchFollowingByUserId(userId: String) async throws -> [Follow] {
        let snapshot = try await Firestore.firestore().collection("follows")
            .whereField("followerId", isEqualTo: userId)
            .getDocuments()
        
        let follows = snapshot.documents.compactMap({ try? $0.data(as: Follow.self) })
        return follows
    }
    
    static func fetchFollowingUsers(following: [Follow]) async throws -> [User] {
        var users: [User] = []
        for follow in following {
            let userEntry = try await fetchUserById(withUid: follow.followingId)
            users.append(userEntry)
        }
        return users
    }
    
    static func fetchFollowersUsers(followers: [Follow]) async throws -> [User] {
        var users: [User] = []
        for follow in followers {
            let userEntry = try await fetchUserById(withUid: follow.followerId)
            users.append(userEntry)
        }
        return users
    }
    
    static func fetchUserProfilePostsByUserId(uid: String) async throws -> [Post] {
        let query = Firestore.firestore()
            .collection("posts")
            .whereField("userId", isEqualTo: uid)
            .order(by: "timestamp", descending: true)
            .limit(to: 20)
        
        let snapshot = try await query.getDocuments()
        let posts = snapshot.documents.compactMap({ try? $0.data(as: Post.self) })
        
        return posts
    }
    
    static func fetchMoreUserProfilePostsByUserId(uid: String, lastPost: Post?) async throws -> [Post] {
        var posts: [Post] = []
        
        if let post = lastPost {
            let query = Firestore.firestore()
                .collection("posts")
                .whereField("userId", isEqualTo: uid)
                .whereField("timestamp", isLessThan: post.timestamp)
                .order(by: "timestamp", descending: true)
                .limit(to: 20)
            
            let snapshot = try await query.getDocuments()
            posts = snapshot.documents.compactMap({ try? $0.data(as: Post.self) })
        } else {
            posts = try await fetchUserProfilePostsByUserId(uid: uid)
        }
        return posts
    }
    
    static func fetchFollowersByUserId(userId: String) async throws -> [Follow] {
        let snapshot = try await Firestore.firestore().collection("follows")
            .whereField("followingId", isEqualTo: userId)
            .getDocuments()
        
        let follows = snapshot.documents.compactMap({ try? $0.data(as: Follow.self) })
        return follows
    }
    
    static func fetchFollowersCount(userId: String) async throws -> Int {
        let snapshot = try await Firestore.firestore().collection("follows")
            .whereField("followingId", isEqualTo: userId)
            .getDocuments()
        
        return snapshot.count
    }
    
    static func fetchFollowingCount(userId: String) async throws -> Int {
        let snapshot = try await Firestore.firestore().collection("follows")
            .whereField("followerId", isEqualTo: userId)
            .getDocuments()
        
        return snapshot.count
    }
    
    static func userAFollowingUserB(userAId: String, userBId: String) async throws -> Bool {
        let snapshot = try await Firestore.firestore().collection("follows")
            .whereField("followerId", isEqualTo: userAId)
            .whereField("followingId", isEqualTo: userBId)
            .getDocuments()
        
        return !snapshot.isEmpty
    }
    
    
}
