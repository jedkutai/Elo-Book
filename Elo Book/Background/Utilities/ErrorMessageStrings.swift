//
//  ErrorMessageStrings.swift
//  Elo
//
//  Created by Jed Kutai on 12/16/23.
//

import SwiftUI

struct ErrorMessageStrings {
    static let emailInUse: String = "The email address is already in use by another account."
    static let genericErrorMessage: String = "Error: An internal error has occurred, print and inspect the error details for more information."
    static let invalidPassword: String = "Error: The password is invalid or the user does not have a password."
    static let tooManyAttempts: String = "Error: Access to this account has been temporarily disabled due to many failed login attempts. You can immediately restore it by resetting your password or you can try again later."
}
