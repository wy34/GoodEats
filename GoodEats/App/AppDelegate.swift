//
//  AppDelegate.swift
//  GoodEats
//
//  Created by William Yeung on 2/8/21.
//

import UIKit
import UserNotifications

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        configureNavbar()
        UITabBar.appearance().tintColor = UIColor(red: 235, green: 75, blue: 27)
        UITabBar.appearance().barTintColor = UIColor(named: "DarkMode")
        
        // Asking permission to send notifications
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in
            if granted {
                print("Granted")
            } else {
                print("Denied")
            }
        }
        
        UNUserNotificationCenter.current().delegate = self
        
        return true
    }
    
    func configureNavbar() {
        let backButtonImage = UIImage(systemName: "arrow.left", withConfiguration: UIImage.SymbolConfiguration(weight: .bold))
        UINavigationBar.appearance().backIndicatorImage = backButtonImage
        UINavigationBar.appearance().backIndicatorTransitionMaskImage = backButtonImage
        UINavigationBar.appearance().prefersLargeTitles = true
        UINavigationBar.appearance().tintColor = UIColor(named: "InvertedDarkMode")
        
        if let largeCustomFont = UIFont(name: "Rubik-Medium", size: 35) {
            UINavigationBar.appearance().largeTitleTextAttributes = [NSAttributedString.Key.font: largeCustomFont, NSAttributedString.Key.foregroundColor: UIColor.init(red: 231, green: 76, blue: 60)]
        }
        
        if let smallCustomFont = UIFont(name: "Rubik-Medium", size: 16) {
            UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.font: smallCustomFont, NSAttributedString.Key.foregroundColor: UIColor.init(red: 231, green: 76, blue: 60)]
        }
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

// MARK: - UserNotificationCenterDelegate
extension AppDelegate: UNUserNotificationCenterDelegate {
    // gets called when a notification action is pressed that brings app into foreground, make sure to set UNUserNotificationCenterDelegate (set in didFinish...)
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        if response.actionIdentifier == "goodEats.call" { // checking which of our notification actions was used (eg. later or call)
            print("Make reservation")
            
            if let phone = response.notification.request.content.userInfo["phone"] { // extracting out the info stored in the occured notification's userInfo dictionary
                let telURL = "tel://\(phone)" // url string to open phone app with the specified phone number
                if let url = URL(string: telURL) { // converting it to URL object
                    if UIApplication.shared.canOpenURL(url) { // checking to see if our app can even open the phone app or not
                        print("Calling \(telURL)")
                        UIApplication.shared.open(url) // actually opening the phone app
                    }
                }
            }
            
            completionHandler()
        }
    }
}
