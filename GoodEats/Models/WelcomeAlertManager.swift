//
//  WelcomeAlert.swift
//  GoodEats
//
//  Created by William Yeung on 2/25/21.
//

import UIKit

class WelcomeAlertManager {
    static let shared = WelcomeAlertManager()
    
    var welcomeAlertUDKey = "welcomeAlert"
    
    var isFirstTimeShowing: Bool {
        return !UserDefaults.standard.bool(forKey: welcomeAlertUDKey)
    }
    
    func stopShowingWelcomeAlert() {
        UserDefaults.standard.setValue(true, forKey: welcomeAlertUDKey)
    }
}
