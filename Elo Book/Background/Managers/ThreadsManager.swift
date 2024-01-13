//
//  ThreadsManager.swift
//  Elo Book
//
//  Created by Jed Kutai on 1/12/24.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

class ThreadsManager: ObservableObject {
    @Published private(set) var threads: [Thread] = []
    let db = Firestore.firestore()
    
    func getThreads(user: User) {
        db.collection("threads")
    }
}

