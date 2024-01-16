//
//  AuthService.swift
//  EloBookv1
//
//  Created by Jed Kutai on 12/23/23.
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseFirestore

struct AuthService {
    
    static func uploadUserData(uid: String, email: String, dateOfBirth: Timestamp) async {
        let user = User(id: uid, email: email.lowercased(), dateOfBirth: dateOfBirth)
        guard let encodedUser = try? Firestore.Encoder().encode(user) else { return }
        try? await Firestore.firestore().collection("users").document(user.id).setData(encodedUser)
    }
    
    static func setUsername(uid: String, username: String) async {
        let userRef = Firestore.firestore().collection("users").document(uid)
        do {
            try await userRef.updateData(["username": username.lowercased()])
            
        } catch {
            print("Error updating username: \(error.localizedDescription)")
        }
    }
    
    @MainActor
    static func createAccount(email: String, password: String, dateOfBirth: Date) async throws -> String {
        let dateOfBirthConverted = Timestamp(date: dateOfBirth)
        do {
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            await uploadUserData(uid: result.user.uid, email: email, dateOfBirth: dateOfBirthConverted)
            
            UserDefaults.standard.set(email, forKey: "email")
            UserDefaults.standard.set(password, forKey: "password")
            
            
            return result.user.uid
        } catch {
            return "\(error.localizedDescription)"
        }
    }
    

    @MainActor
    static func login(withEmail email: String, password: String) async throws -> String {
        do {
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            UserDefaults.standard.set(email, forKey: "email")
            UserDefaults.standard.set(password, forKey: "password")
            return result.user.uid
        } catch {
            print("DEBUG: \(error.localizedDescription)")
            return "Error: \(error.localizedDescription)"
        }
        
    }
    
    static func fetchUserById(withUid uid: String) async throws -> User {
        let snapshot = try await Firestore.firestore().collection("users").document(uid).getDocument()
        return try snapshot.data(as: User.self)
    }
    
    static func resetPassword(withEmail email: String) async throws {
        try await Auth.auth().sendPasswordReset(withEmail: email)
    }
    
    
}
