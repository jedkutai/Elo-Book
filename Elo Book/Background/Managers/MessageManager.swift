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
    @Published private(set) var messagesInfo = [String: MessageInfo]()
    @Published private(set) var lastMessageId = ""
    
    let db = Firestore.firestore()
    
    init(thread: Thread, user: User) {
        getMessages(thread: thread, user: user)
    }
    
    func getMessages(thread: Thread, user: User) {
        db.collection("threads").document(thread.id).collection("messages").order(by: "timestamp", descending: false).limit(to: 40).addSnapshotListener { querySnapshot, error in
            guard let documents = querySnapshot?.documents else {
                print("Error fetching documents: \(String(describing: error))")
                return
            }
            
            self.messages = documents.compactMap({ try? $0.data(as: Message2.self) })
            
            if let id = self.messages.last?.id {
                self.lastMessageId = id
            }
            
            var lastMessage: Message2?
            for message in self.messages {
                
                var byUser: Bool = false
                var showTime: Bool = false
                var showName: Bool = false
                var showIcon: Bool = true // needs to be changed by the upcoming message
                
                if message.userId == user.id {
                    byUser = true
                    showIcon = false
                    // showName stays false
                    if let lastMessage = lastMessage {
                        let lastMessageTime = lastMessage.timestamp.dateValue()
                        let currentMessageTime = message.timestamp.dateValue()
                        let timeDifference = currentMessageTime.timeIntervalSince(lastMessageTime)
                        if timeDifference >= 3600 {
                            showTime = true
                        }
                    } else {
                        showTime = true
                    }
                    
                } else {
                    // byUser stays false
                    if let lastMessage = lastMessage {
                        if lastMessage.userId == message.userId {
                            let lastMessageTime = lastMessage.timestamp.dateValue()
                            let currentMessageTime = message.timestamp.dateValue()
                            let timeDifference = currentMessageTime.timeIntervalSince(lastMessageTime)
                            if timeDifference >= 3600 {
                                showTime = true
                                showName = true
                                // show icon of last message stays true
                            } else {
                                self.messagesInfo[lastMessage.id]?.showIcon = false
                            }
                        } else {
                            showName = true
                        }
                        
                    } else {
                        showName = true
                        showTime = true
                        // showIcon stays true
                    }
                    
                }
                
                lastMessage = message
                self.messagesInfo[message.id] = MessageInfo(byUser: byUser, showTime: showTime, showName: showName, showIcon: showIcon)
            }
            
        }
    }
}
