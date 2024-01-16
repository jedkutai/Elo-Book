//
//  EventChatManager.swift
//  Elo Book
//
//  Created by Jed Kutai on 1/14/24.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

class EventChatManager: ObservableObject {
    @Published private(set) var chats: [Chat] = []
    @Published private(set) var lastChatId = ""
    
    let db = Firestore.firestore()
    
    init(event: Event) {
        getMessages(event: event)
    }
    
    func getMessages(event: Event) {
        db.collection("events").document(event.id).collection("chats").order(by: "timestamp", descending: false).limit(to: 25).addSnapshotListener { querySnapshot, error in
            guard let documents = querySnapshot?.documents else {
                print("Error fetching documents: \(String(describing: error))")
                return
            }
            
            self.chats = documents.compactMap({ try? $0.data(as: Chat.self) })
            
            if let id = self.chats.last?.id {
                self.lastChatId = id
            }
            
        }
    }
}
