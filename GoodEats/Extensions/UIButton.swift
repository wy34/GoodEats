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
//        button.alpha = 0
        return button
    }
}

