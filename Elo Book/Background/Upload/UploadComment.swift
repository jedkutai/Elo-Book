//
//  UploadComment.swift
//  EloBook
//
//  Created by Jed Kutai on 11/2/23.
//

import Foundation
import PhotosUI
import SwiftUI
import Firebase
import FirebaseFirestore
import UIKit


@MainActor
class UploadComment: ObservableObject {
    
    @Published var selectedImage: PhotosPickerItem? {
        didSet { Task {await loadImage(fromItem: selectedImage) } }
    }
    
    @Published var postImage: Image?
    private var uiImage: UIImage?
    
    func loadImage(fromItem item: PhotosPickerItem?) async {
        guard let item = item else { return }
        
        guard let data = try? await item.loadTransferable(type: Data.self) else { return }
        guard let uiImage = UIImage(data: data) else { return }
        self.uiImage = uiImage
        self.postImage = Image(uiImage: uiImage)
    }
    
    func uploadComment(user: User, post: Post, caption: String) async throws {

        let commentRef = Firestore.firestore().collection("posts").document(post.id).collection("comments").document()
        let commentDocId = commentRef.documentID
        
        let comment = Comment(id: commentDocId, postId: post.id, userId: user.id, caption: caption, timestamp: Timestamp())
        guard let encodedComment = try? Firestore.Encoder().encode(comment) else { return }
        
        try await commentRef.setData(encodedComment)
        
        let docRef = Firestore.firestore().collection("posts").document(post.id)
        let document = try await docRef.getDocument()
        var post = try document.data(as: Post.self)
        post.score += 3
        let updatedData = try Firestore.Encoder().encode(post)
        try await docRef.setData(updatedData, merge: true)
        
        if post.userId != user.id {
            let commentOnPostRef = Firestore.firestore().collection("users").document(post.userId).collection("commentOnPostAlerts").document(commentDocId)
            
            let alert = CommentOnPostAlert(id: commentDocId, postId: post.id, userId: user.id)
            guard let encodedAlert = try? Firestore.Encoder().encode(alert) else { return }
            
            try await commentOnPostRef.setData(encodedAlert)
        }
        
    }

}
