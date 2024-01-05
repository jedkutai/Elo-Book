//
//  CreateAccountControllerView.swift
//  EloBookv1
//
//  Created by Jed Kutai on 12/23/23.
//

import SwiftUI

enum createAccountViewShown {
    case createAccount
    case selectUsername
    case welcome
}

struct CreateAccountControllerView: View {
    @State private var userId = ""
    @State private var viewShown: createAccountViewShown = .createAccount
    @State private var user: User = User.MOCK_USER
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        switch viewShown {
        case .createAccount:
            CreateAccountView(userId: $userId, viewShown: $viewShown, dismiss: dismiss)
        case .selectUsername:
            SelectUsernameView(userId: $userId, viewShown: $viewShown)
        case .welcome:
            WelcomeView(user: $user, userId: $userId)
        }
    }
}

#Preview {
    CreateAccountControllerView()
}
