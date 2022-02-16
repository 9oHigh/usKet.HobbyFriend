//
//  AppDelegate.swift
//  usKet_Friend
//
//  Created by 이경후 on 2022/01/17.
//

import UIKit
import Firebase
import UserNotifications
import IQKeyboardManagerSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // Firebase
        FirebaseApp.configure()
        
        // Notification
        UNUserNotificationCenter.current().delegate = self
        Messaging.messaging().delegate = self
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { _, _ in }
        
        application.registerForRemoteNotifications()
        
        // Keyboard
        IQKeyboardManager.shared.enable = true
        
        // UIAppearence - NavigationBar
        UINavigationBar.appearance().backIndicatorImage = R.image.letfArrow()
        UINavigationBar.appearance().backIndicatorTransitionMaskImage = R.image.letfArrow()
        UINavigationBar.appearance().tintColor = UIColor(resource: R.color.basicBlack)
        
        let appearance = UINavigationBarAppearance()
        let navigationBar = UINavigationBar()
        
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .white
        navigationBar.standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        
        return true
    }
    
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        
    }
    
    // MARK: 나중에 확인해보기
    /*
     func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
     Messaging.messaging().apnsToken = deviceToken
     }
     */
}

extension AppDelegate: MessagingDelegate {
    // 토큰 받기
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        
        lazy var signup = Helper()
        
        guard let fcmToken = fcmToken else {
            signup.registerUserData(userDataType: .FCMtoken, variable: "None")
            return
        }
        signup.registerUserData(userDataType: .FCMtoken, variable: fcmToken)
        
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        completionHandler(UIBackgroundFetchResult.newData)
    }
    // 앱이 종료되는 시점에서 StopFinding + 매치 상태 조정
    func applicationWillTerminate(_ application: UIApplication) {
        print(#function)
        let idToken = Helper.shared.putIdToken()
        
        Helper.shared.registerUserData(userDataType: .isMatch, variable: MatchStatus.nothing.rawValue)
        
        QueueAPI.stopFinding(idToken: idToken) { _ in }
    }
}
// 노티수신(Firebase)
extension AppDelegate: UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([ .banner, .badge, .sound])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        completionHandler()
    }
}
