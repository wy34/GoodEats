//
//  AppDelegate.swift
//  GoodEats
//
//  Created by William Yeung on 2/8/21.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        configureNavbar()
        UITabBar.appearance().tintColor = UIColor(red: 235, green: 75, blue: 27)
        UITabBar.appearance().barTintColor = UIColor(named: "DarkMode")
        return true
    }
    
    func configureNavbar() {
        let backButtonImage = UIImage(systemName: "arrow.left", withConfiguration: UIImage.SymbolConfiguration(weight: .bold))
        UINavigationBar.appearance().backIndicatorImage = backButtonImage
        UINavigationBar.appearance().backIndicatorTransitionMaskImage = backButtonImage
        UINavigationBar.appearance().prefersLargeTitles = true
        
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

