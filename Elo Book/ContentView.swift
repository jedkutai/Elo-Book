//
//  ContentView.swift
//  EloBookv1
//
//  Created by Jed Kutai on 12/23/23.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @EnvironmentObject var x: X
    
    @State private var userId = ""
    @State private var user: User?
    
    @State private var loggedIn = false
    @State private var failedLogin = false
    
    var body: some View {
        if x.email.isEmpty || failedLogin {
            FirstOpenView()
        }
        else if let loggedInUser = user {
            MainTabControllerView(user: loggedInUser)
        }
        else {
            LogoView()
                .onAppear {
                    Task {
                        userId = try await AuthService.login(withEmail: x.email, password: x.password)
                        if !userId.hasPrefix("Error:") {
                            user = try await AuthService.fetchUserById(withUid: userId)
                            loggedIn = true
                        } else {
                            failedLogin = true
                        }
                    }
                }
        }
    }
    

}

#Preview {
    ContentView()
}
