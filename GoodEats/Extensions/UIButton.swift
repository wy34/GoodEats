//
//  UIButton.swift
//  GoodEats
//
//  Created by William Yeung on 2/11/21.
//

import UIKit

extension UIButton {
    static func createRatingButton(withImage image: String, andTitle title: String) -> UIButton {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: image)?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.setTitle(title, for: .normal)
        button.tintColor = .white
        button.titleLabel?.adjustsFontForContentSizeCategory = true
        button.titleLabel?.font = UIFontMetrics(forTextStyle: .headline).scaledFont(for: UIFont(name: "Rubik", size: 50)!)
        return button
    }
    
    static func createOnboardingVCButtons(title: String, titleColor: UIColor, bgColor: UIColor, textStyle: UIFont.TextStyle) -> UIButton {
        let button = UIButton(type: .system)
        button.backgroundColor = bgColor
        button.setTitle(NSLocalizedString(title, comment: title), for: .normal)
        button.setTitleColor(titleColor, for: .normal)
        button.titleLabel?.font = UIFont.preferredFont(forTextStyle: textStyle)
        return button
    }
}

