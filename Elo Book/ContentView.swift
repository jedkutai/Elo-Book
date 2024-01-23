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
    
    @State private var user: User?
    
    @State private var loggedIn = false
    @State private var failedLogin = false
    
    var body: some View {
        if x.uid.isEmpty || failedLogin {
            FirstOpenView()
        }
        else if let loggedInUser = user {
            MainTabControllerView(user: loggedInUser)
        }
        else {
            LogoView()
                .onAppear {
                    Task {
                        if !x.uid.isEmpty {
                            do {
                                user = try await AuthService.fetchUserById(withUid: x.uid)
                                if let user = user {
                                    if user.id == x.uid {
                                        loggedIn = true
                                    } else {
                                        failedLogin = true
                                    }
                                } else {
                                    failedLogin = true
                                }
                            } catch {
                                failedLogin = true
                            }
                            
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
