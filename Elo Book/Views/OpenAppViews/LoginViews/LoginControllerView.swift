//
//  LoginControllerView.swift
//  EloBookv1
//
//  Created by Jed Kutai on 12/23/23.
//

import SwiftUI

enum loginViewShown {
    case login
    case welcomeUser
    case selectUsername
}

struct LoginControllerView: View {
    @State private var userId = ""
    @State private var currentView: loginViewShown = .login
    @State private var user: User = User.MOCK_USER
    @Environment(\.dismiss) private var dismiss
    var body: some View {
        switch currentView {
        case .login:
            LoginView(userId: $userId, currentView: $currentView, dismiss: dismiss)
        case .welcomeUser:
            WelcomeAltView(userId: $userId, currentView: $currentView, user: $user)
        case .selectUsername:
            SelectUsernameAltView(userId: $userId, currentView: $currentView)
        }
    }
}

#Preview {
    LoginControllerView()
}
