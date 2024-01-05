//
//  Elo_BookApp.swift
//  Elo Book
//
//  Created by Jed Kutai on 1/4/24.
//

import SwiftUI
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        return true
    }
}

@main
struct Elo_BookApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject private var x = X()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(x)
                .onOpenURL { url in
                    x.handleDeepLink(url: url)
                }
        }
    }
}
