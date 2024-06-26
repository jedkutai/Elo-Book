//
//  Checks.swift
//  Elo
//
//  Created by Jed Kutai on 12/16/23.
//

import Foundation
import SwiftUI
import Firebase
import FirebaseAuth
import FirebaseFirestore
import Contacts
import Combine

class Checks {
    
    // Function to extract numeric phone numbers from CNContact
    static func extractNumericPhoneNumbers(from contact: CNContact) -> [String] {
        var numericPhoneNumbers: [String] = []

        for phoneNumber in contact.phoneNumbers {
            let phoneNumberString = phoneNumber.value.stringValue
            let numericPhoneNumber = phoneNumberString.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
            numericPhoneNumbers.append(String(numericPhoneNumber.suffix(10)))
        }

        return numericPhoneNumbers
    }
    
    static func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
    
    static func isValidPassword(_ password: String) -> Bool {
        return password.count >= 8 && !password.contains(" ")
    }

    static func isValidSignUp (_ email: String, _ password: String, _ confirmPassword: String) -> Bool {
        return isValidEmail(email) && isValidPassword(password) && password == confirmPassword
    }
    
    static func isValidUsername(_ username: String) -> Bool {
        let usernameCharacterSet = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789_")
        return username.count >= 4 && username.rangeOfCharacter(from: usernameCharacterSet.inverted) == nil && username.count <= 16
    }
    
    static func isValidCommunityName(_ name: String) -> Bool {
        let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedName.isEmpty else {
            return false
        }
        
        let nameCharacterSet = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789_- ")
        return name.count >= 1 && name.rangeOfCharacter(from: nameCharacterSet.inverted) == nil && name.count <= 50
    }
    
    static func isUsernameAvailable (_ username: String) async -> Bool {
        do {
            let db = Firestore.firestore()
            let usernamesRef = db.collection("users")
            let query = usernamesRef.whereField("username", isEqualTo: username.lowercased())
            let data = try await query.getDocuments()
            if data.isEmpty {
                return true
            } else {
                return false
            }
        } catch {
            print("DEBUG: Failed to check username: \(error.localizedDescription)")
            return false
        }
    }
    
    static func isValidCaption(_ caption: String) -> Bool {
        guard !caption.isEmpty else {
            return false
        }
        
        let trimmedCaption = caption.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedCaption.isEmpty else {
            return false
        }
        
        guard caption.count <= 1000 else {
                return false
            }
        
        return true
    }
    
    static func isValidCommentCaption(_ caption: String) -> Bool {
        guard !caption.isEmpty else {
            return false
        }
        
        let trimmedCaption = caption.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedCaption.isEmpty else {
            return false
        }
        
        guard caption.count <= 300 else {
                return false
            }
        
        return true
    }
    
    static func isUserOver21(_ birthDate: Date) -> Bool {
        let calendar = Calendar.current
        if let date18YearsAgo = calendar.date(byAdding: .year, value: -21, to: Date()) {
            return birthDate <= date18YearsAgo
        }
        return false
    }

    static func isValidName(_ name: String) -> Bool {
        let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        return !trimmedName.isEmpty && trimmedName.count >= 0 && trimmedName.count <= 35
    }
    
    static func isValidBio(_ bio: String) -> Bool {
        let trimmedBio = bio.trimmingCharacters(in: .whitespacesAndNewlines)
        return !trimmedBio.isEmpty && trimmedBio.count >= 0 && trimmedBio.count <= 150
    }

    
    static func isValidSearch(_ searchTerm: String) -> Bool {
        let trimmedSearchTerm = searchTerm.trimmingCharacters(in: .whitespaces)
        return !trimmedSearchTerm.isEmpty && searchTerm.count >= 1 && searchTerm.count <= 30
    }
    
    static func isValidPhoneNumber(_ phoneNumber: String) -> Bool {
        let phoneRegex = #"^\d{10}$"#
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
        return phoneTest.evaluate(with: phoneNumber)
    }
    
}
