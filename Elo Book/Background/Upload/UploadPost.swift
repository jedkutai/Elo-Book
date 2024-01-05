//
//  UploadPost.swift
//  EloBook
//
//  Created by Jed Kutai on 10/31/23.
//

import Foundation
import PhotosUI
import SwiftUI
import Firebase
import UIKit

@MainActor
class UploadPost: ObservableObject {

    @Published var postImages: [Image] = []
    var uiImages: [UIImage] = []
    
    
    func loadImages(fromItem items: [PhotosPickerItem]) async {
        for item in items {
            
            guard let data = try? await item.loadTransferable(type: Data.self) else { return }
            guard let uiImage = (UIImage(data: data)) else { return }
            self.uiImages.append(uiImage)
            self.postImages.append(Image(uiImage: uiImage))
        }
    }
    
    func uploadPost(user: User, caption: String, events: [Event]) async throws {
        let uid = user.id
        
        let eventIds = events.map { $0.id }
        
        let postRef = Firestore.firestore().collection("posts").document()
        let docId = postRef.documentID
        
        var filenames: [String] = []
        var imageUrls: [String] = []
        
        for uiImage in uiImages {
            let filename = NSUUID().uuidString
            guard let imageUrl = try await ImageUploader.uploadPostImage(uid: uid, image: uiImage, filename: filename) else { return }
            filenames.append(filename)
            imageUrls.append(imageUrl)
        }
        
        
        let post = Post(id: docId, userId: uid, caption: caption, imageUrls: imageUrls, imageIds: filenames, eventIds: eventIds, timestamp: Timestamp())
        guard let encodedPost = try? Firestore.Encoder().encode(post) else { return }
        

        
        try await postRef.setData(encodedPost)
        
        
    }

}
