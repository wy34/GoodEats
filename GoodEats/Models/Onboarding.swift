//
//  Restaurant.swift
//  GoodEats
//
//  Created by William Yeung on 2/8/21.
//

import Foundation

struct Onboarding {
    var image: String
    var headline: String
    var subHeadline: String
}


class OnboardingManager {
    static let shared = OnboardingManager()
    
    var onboardingUDKey = "onboardingUDKey"
    
    var isOldUser: Bool {
        return UserDefaults.standard.bool(forKey: onboardingUDKey)
    }
    
    func setAsOldUser() {
        UserDefaults.standard.setValue(true, forKey: onboardingUDKey)
    }
}
