//
//  MessageManager.swift
//  Elo Book
//
//  Created by Jed Kutai on 1/12/24.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

class MessageManager: ObservableObject {
    @Published private(set) var messages: [Message2] = []
    let db = Firestore.firestore()
    
    init(thread: Thread) {
        getMessages(thread: thread)
    }
    
    func getMessages(thread: Thread) {
        db.collection("threads").document(thread.id).collection("messages").order(by: "timestamp", descending: false).addSnapshotListener { querySnapshot, error in
            guard let documents = querySnapshot?.documents else {
                print("Error fetching documents: \(String(describing: error))")
                return
            }
            
            self.messages = documents.compactMap({ try? $0.data(as: Message2.self) })
            
//            self.messages = documents.compactMap { document -> Message2? in
//                do {
//                    return try document.data(as: Message2.self)
//                } catch {
//                    print("error decoding document into Message: \(error)")
//                    return nil
//                }
//            }
//            
//            self.messages.sort { $0.timestamp.dateValue() < $1.timestamp.dateValue() }
            
        }
    }
}
