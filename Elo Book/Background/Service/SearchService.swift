//
//  SearchService.swift
//  Elo
//
//  Created by Jed Kutai on 12/16/23.
//

import Foundation
import Firebase
import FirebaseFirestore

struct SearchService {
    
    static func searchLocallyForUsernames(searchText: String, users: [User], limit: Int) -> [User] {
        let splitTerms = searchText.components(separatedBy: " ").map { $0.lowercased() }
        
        let searchResults = users.filter { user in
            if let username = user.username {
                return splitTerms.contains { term in
                    return username.lowercased().contains(term)
                }
            } else {
                return false
            }
            
        }
        
        if limit > 0 {
            return Array(searchResults.prefix(limit))
        } else {
            return searchResults
        }
    }
    
    static func searchDatabaseUsernames(searchTerm: String, limit: Int = 0) async throws -> [User] {
        let searchterm_lc = searchTerm.lowercased()
        var users: [User] = []
        
        if limit > 0 {
            let query = Firestore.firestore()
                .collection("users")
                .whereField("username", isGreaterThanOrEqualTo: searchterm_lc)
                .whereField("username", isLessThanOrEqualTo: searchterm_lc + "\u{f8ff}")
                .limit(to: limit)
            
            let snapshot = try await query.getDocuments()
            users = snapshot.documents.compactMap({ try? $0.data(as: User.self) })
        } else {
            let query = Firestore.firestore()
                .collection("users")
                .whereField("username", isGreaterThanOrEqualTo: searchterm_lc)
                .whereField("username", isLessThanOrEqualTo: searchterm_lc + "\u{f8ff}")
            
            let snapshot = try await query.getDocuments()
            users = snapshot.documents.compactMap({ try? $0.data(as: User.self) })
        }
        
        return users
    }
    static func searchDatabaseForUsernames(searchTerm: String, limit: Int = 0) async throws -> [User] {
        let searchterm_lc = searchTerm.lowercased()
        var users: [User] = []
        
        if limit > 0 {
            let query = Firestore.firestore()
                .collection("users")
                .whereField("username", isGreaterThanOrEqualTo: searchterm_lc)
                .whereField("username", isLessThanOrEqualTo: searchterm_lc + "\u{f8ff}")
                .limit(to: limit)
            
            let snapshot = try await query.getDocuments()
            users = snapshot.documents.compactMap({ try? $0.data(as: User.self) })
        } else {
            let query = Firestore.firestore()
                .collection("users")
                .whereField("username", isGreaterThanOrEqualTo: searchterm_lc)
                .whereField("username", isLessThanOrEqualTo: searchterm_lc + "\u{f8ff}")
            
            let snapshot = try await query.getDocuments()
            users = snapshot.documents.compactMap({ try? $0.data(as: User.self) })
        }
        
        return users
    }
    
    static func searchTeams(searchText: String, teams: [Team]) -> [Team] {
        let splitTerms = searchText.components(separatedBy: " ").map { $0.lowercased() }
        
        // Filter the teams array based on the search criteria
        let searchResults = teams.filter { team in
            let teamName = team.teamName.lowercased()
            return splitTerms.contains { term in
                return teamName.contains(term)
            }
        }
        
        return searchResults
    }
    
    
    
    
    static func searchDatabaseForEvents(searchTerm: String, limit: Int = 0) async throws -> [Event] {
        let splitTerms = searchTerm.components(separatedBy: " ").map { $0.lowercased() }
        var events: [Event] = []
        let currentTime = Timestamp(date: Date())
        
        if limit > 0 {
            let query = Firestore.firestore()
                .collection("events")
                .whereField("title_lc", arrayContainsAny: splitTerms)
                .whereField("timestamp", isGreaterThan: currentTime)
                .order(by: "timestamp")
                .limit(to: limit)
            
            let snapshot = try await query.getDocuments()
            events = snapshot.documents.compactMap({ try? $0.data(as: Event.self) })
            
        } else {
            let query = Firestore.firestore()
                .collection("events")
                .whereField("title_lc", arrayContainsAny: splitTerms)
                .whereField("timestamp", isGreaterThan: currentTime)
                .order(by: "timestamp")
             
            let snapshot = try await query.getDocuments()
            events = snapshot.documents.compactMap({ try? $0.data(as: Event.self) })
        }
        
        let query2 = Firestore.firestore()
            .collection("events")
            .whereField("title_lc", arrayContainsAny: splitTerms)
            .whereField("timestamp", isLessThanOrEqualTo: currentTime)
            .order(by: "timestamp", descending: true)
            .limit(to: 5)
        
        let snapshot2 = try await query2.getDocuments()
        events += snapshot2.documents.compactMap({ try? $0.data(as: Event.self) })
        
        return events
    }

    
    static func searchLocallyForEvents(in events: [Event], for searchString: String) -> [Event] {
        let lowercasedSearchString = searchString.lowercased()

        let filteredEvents = events.filter { event in
            // Check if the event title contains the search string
            if event.title.lowercased().contains(lowercasedSearchString) {
                return true
            }

            // Check if the sport contains the search string
            if event.sport.lowercased().contains(lowercasedSearchString) {
                return true
            }

            // You can add additional properties here if needed

            return false
        }

        return filteredEvents
    }


}
