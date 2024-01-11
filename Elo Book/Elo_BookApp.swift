//
//  Elo_BookApp.swift
//  Elo Book
//
//  Created by Jed Kutai on 1/4/24.
//

import SwiftUI
import FirebaseCore
import Firebase
import UserNotifications
import FirebaseMessaging

class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate, MessagingDelegate {
    func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        
        FirebaseApp.configure()
        Analytics.setAnalyticsCollectionEnabled(true)

        
        // push notifications
        UNUserNotificationCenter.current().delegate = self
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(
          options: authOptions,
          completionHandler: { _, _ in }
        )
        application.registerForRemoteNotifications()

        Messaging.messaging().delegate = self
        
        Messaging.messaging().token { token, error in
            
          if let error = error {
            print("Error fetching FCM registration token: \(error)")
          } else if let token = token {
            print("FCM registration token: \(token)")
//            self.fcmRegTokenMessage.text  = "Remote FCM registration token: \(token)"
          }
        }
        
        Messaging.messaging().isAutoInitEnabled = true
        

        return true
    }
    
    func application(_ application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
      Messaging.messaging().apnsToken = deviceToken
    }
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
      print("Firebase registration token: \(String(describing: fcmToken))")

      let dataDict: [String: String] = ["token": fcmToken ?? ""]
        if let userToken = fcmToken {
            UserDefaults.standard.set(userToken, forKey: "fcmToken")
        }
      NotificationCenter.default.post(
        name: Notification.Name("FCMToken"),
        object: nil,
        userInfo: dataDict
      )
      // TODO: If necessary send token to application server.
      // Note: This callback is fired at each app startup and whenever a new token is generated.
    }
    
    func application(_ application: UIApplication,
                     didReceiveRemoteNotification userInfo: [AnyHashable: Any]) async
      -> UIBackgroundFetchResult {
      // If you are receiving a notification message while your app is in the background,
      // this callback will not be fired till the user taps on the notification launching the application.
      // TODO: Handle data of notification

      // With swizzling disabled you must let Messaging know about the message, for Analytics
      // Messaging.messaging().appDidReceiveMessage(userInfo)
          let gcmMessageIDKey = "gcm.message_id"

      // Print message ID.
      if let messageID = userInfo[gcmMessageIDKey] {
        print("Message ID: \(messageID)")
      }

      // Print full message.
      print(userInfo)

      return UIBackgroundFetchResult.newData
    }


}


extension AppDelegate {
  // Receive displayed notifications for iOS 10 devices.
  func userNotificationCenter(_ center: UNUserNotificationCenter,
                              willPresent notification: UNNotification) async
    -> UNNotificationPresentationOptions {
    let userInfo = notification.request.content.userInfo

    // With swizzling disabled you must let Messaging know about the message, for Analytics
    // Messaging.messaging().appDidReceiveMessage(userInfo)

    // ...

    // Print full message.
    print(userInfo)

    // Change this to your preferred presentation option
    return [[.banner, .sound]] // changed from .alert to .banner, test when i wake up
  }

  func userNotificationCenter(_ center: UNUserNotificationCenter,
                              didReceive response: UNNotificationResponse) async {
    let userInfo = response.notification.request.content.userInfo

    // ...

    // With swizzling disabled you must let Messaging know about the message, for Analytics
    // Messaging.messaging().appDidReceiveMessage(userInfo)

    // Print full message.
    print(userInfo)
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
