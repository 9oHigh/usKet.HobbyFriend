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
        
        //Firebase
        FirebaseApp.configure()
        
        //Notification
        UNUserNotificationCenter.current().delegate = self
        Messaging.messaging().delegate = self
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in }
        
        application.registerForRemoteNotifications()
        
        //Keyboard
        IQKeyboardManager.shared.enable = true
        
        //UIAppearence - NavigationBar
        UINavigationBar.appearance().backIndicatorImage = R.image.letfArrow()
        UINavigationBar.appearance().backIndicatorTransitionMaskImage = R.image.letfArrow()
        UINavigationBar.appearance().tintColor = UIColor(resource:R.color.basicBlack)
        
        return true
    }
    
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        
    }
    
    /*
     MARK: 나중에 확인해보기
     func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
         Messaging.messaging().apnsToken = deviceToken
     }
     */
}

extension AppDelegate : MessagingDelegate{
    //토큰 받기
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        
        lazy var toSignUp = LoginSingleTon()
        
        guard let fcmToken = fcmToken else {
            toSignUp.registerUserData(userDataType: .FCMToken, variableType: String.self, variable: "None")
            return
        }
        toSignUp.registerUserData(userDataType: .FCMToken, variableType: String.self, variable: fcmToken)

    }
    
    //받은 메세지 처리 메서드 -> 나중에 알림오는 단계에서 해보자.
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                         fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
            // TODO: Handle data of notification
            completionHandler(UIBackgroundFetchResult.newData)
        }
}
//노티수신(Firebase)
extension AppDelegate : UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,willPresent notification: UNNotification,withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([ .banner , .badge, .sound])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,didReceive response: UNNotificationResponse,withCompletionHandler completionHandler: @escaping () -> Void) {
        completionHandler()
    }
}
