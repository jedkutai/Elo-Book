//
//  ImageUploader.swift
//  EloBook
//
//  Created by Jed Kutai on 10/31/23.
//

import UIKit
import Firebase
import FirebaseStorage

struct ImageUploader {
    static func uploadPostImage(uid: String, image: UIImage, filename: String) async throws -> String? {
        guard let imageData = image.jpegData(compressionQuality: 1) else { return nil }
        let ref = Storage.storage().reference(withPath: "/\(uid)/post_images/\(filename)")
        
        do {
            let _  = try await ref.putDataAsync(imageData)
            let url = try await ref.downloadURL()
            return url.absoluteString
        } catch {
            print("DEBUG: Failed to upload image with error \(error.localizedDescription)")
            return nil
        }
    }
    
    static func uploadMessageImage(uid: String, image: UIImage, filename: String) async throws -> String? {
        guard let imageData = image.jpegData(compressionQuality: 1) else { return nil }
        let ref = Storage.storage().reference(withPath: "/\(uid)/message_images/\(filename)")
        
        do {
            let _  = try await ref.putDataAsync(imageData)
            let url = try await ref.downloadURL()
            return url.absoluteString
        } catch {
            print("DEBUG: Failed to upload image with error \(error.localizedDescription)")
            return nil
        }
    }
    
    static func uploadCommentImage(uid: String, image: UIImage, filename: String) async throws -> String? {
        guard let imageData = image.jpegData(compressionQuality: 1) else { return nil }
        let ref = Storage.storage().reference(withPath: "/\(uid)/comment_images/\(filename)")
        
        do {
            let _  = try await ref.putDataAsync(imageData)
            let url = try await ref.downloadURL()
            return url.absoluteString
        } catch {
            print("DEBUG: Failed to upload image with error \(error.localizedDescription)")
            return nil
        }
    }
    
    static func uploadProfileImage(uid: String, image: UIImage, filename: String) async throws -> String? {
        guard let imageData = image.jpegData(compressionQuality: 1) else { return nil }
        let ref = Storage.storage().reference(withPath: "/\(uid)/profile_images/\(filename)")
        
        do {
            let _  = try await ref.putDataAsync(imageData)
            let url = try await ref.downloadURL()
            return url.absoluteString
        } catch {
            print("DEBUG: Failed to upload image with error \(error.localizedDescription)")
            return nil
        }
    }
    
    static func uploadGroupChatProfileImage(threadId: String, image: UIImage, filename: String) async throws -> String? {
        guard let imageData = image.jpegData(compressionQuality: 1) else { return nil }
        let ref = Storage.storage().reference(withPath: "/\(threadId)/profile_images/\(filename)")
        
        do {
            let _  = try await ref.putDataAsync(imageData)
            let url = try await ref.downloadURL()
            return url.absoluteString
        } catch {
            print("DEBUG: Failed to upload image with error \(error.localizedDescription)")
            return nil
        }
    }
    
    
}
