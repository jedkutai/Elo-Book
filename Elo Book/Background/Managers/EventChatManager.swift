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
    @Published private(set) var messages: [Message2] = []
    @Published private(set) var messagesInfo = [String: MessageInfo]()
    @Published private(set) var lastMessageId = ""
    @Published private(set) var chatterIds: [String] = []
    
    let db = Firestore.firestore()
    
    init(event: Event, user: User) {
        getMessages(event: event, user: user)
    }
    
    func getMessages(event: Event, user: User) {
        db.collection("events").document(event.id).collection("messages").order(by: "timestamp", descending: false).limit(to: 25).addSnapshotListener { querySnapshot, error in
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
                let messageUserId = message.userId
                self.chatterIds.append(messageUserId)
                    
                var byUser: Bool = false
                var showTime: Bool = false
                var showName: Bool = false
                var showIcon: Bool = true // needs to be changed by the upcoming message
                
                if messageUserId == user.id {
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
                        if lastMessage.userId == messageUserId {
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
