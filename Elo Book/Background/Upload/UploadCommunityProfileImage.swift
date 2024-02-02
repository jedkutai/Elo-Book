//
//  UploadCommunityProfileImage.swift
//  Elo Book
//
//  Created by Jed Kutai on 1/26/24.
//

import Foundation
import PhotosUI
import SwiftUI
import Firebase
import FirebaseStorage
import FirebaseFirestore
import UIKit

@MainActor
class UploadCommunityProfileImage: ObservableObject {
    
//    @Published var selectedImage: PhotosPickerItem? {
//        didSet { Task {await loadImage(fromItem: selectedImage) } }
//    }
//    
//    @Published var profileImage: Image?
//    var uiImage: UIImage?
//    
//    func loadImage(fromItem item: PhotosPickerItem?) async {
//        guard let item = item else { return }
//        
//        guard let data = try? await item.loadTransferable(type: Data.self) else { return }
//        guard let uiImage = UIImage(data: data) else { return }
//        self.uiImage = uiImage
//        self.profileImage = Image(uiImage: uiImage)
//    }
//    
//    func uploadProfileImage(user: User) async throws {
//        
//        guard let uiImage = uiImage else { return }
//        
//        let userRef = Firestore.firestore().collection("users").document(user.id)
//        let filename = NSUUID().uuidString
//        
//        guard let imageUrl = try await ImageUploader.uploadProfileImage(uid: user.id, image: uiImage, filename: filename) else { return }
//        
//        if let profileImageId = user.profileImageId {
//            let ref = Storage.storage().reference(withPath: "/\(user.id)/profile_images/\(profileImageId)")
//            try await ref.delete()
//        }
//        
//        try await userRef.updateData(["profileImageUrl": imageUrl])
//        try await userRef.updateData(["profileImageId": filename])
//    }
    
}
