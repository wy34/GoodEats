//
//  UILabel.swift
//  GoodEats
//
//  Created by William Yeung on 2/22/21.
//

import UIKit

extension UILabel {
    static func createLabel(text: String? = nil, textColor: UIColor = .black, textStyle: UIFont.TextStyle, numberOfLines: Int = 1) -> UILabel {
        let label = UILabel()
        if let text = text {
            label.text = NSLocalizedString(text, comment: text)
        }
        label.font = UIFont.preferredFont(forTextStyle: textStyle)
        label.textColor = textColor
        label.numberOfLines = numberOfLines
        return label
    }
    
    static func createEmptyViewLabel(text: String, textColor: String, fontSize: CGFloat) -> UILabel {
        let label = UILabel()
        label.text = NSLocalizedString(text, comment: text)
        label.textColor = UIColor(named: textColor)
        label.textAlignment = .center
        label.numberOfLines = 2
        label.adjustsFontForContentSizeCategory = true
        label.font = UIFontMetrics(forTextStyle: .body).scaledFont(for: UIFont(name: "Rubik-Medium", size: fontSize)!)
        return label
    }
    
    static func createLabel(textColor: UIColor, fontName: String, textStyle: UIFont.TextStyle, fontSize: CGFloat, alignment: NSTextAlignment) -> UILabel {
        let label = UILabel()
        label.adjustsFontForContentSizeCategory = true
        label.font = UIFontMetrics(forTextStyle: textStyle).scaledFont(for: UIFont(name: fontName, size: fontSize)!)
        label.textColor = textColor
        label.textAlignment = alignment
        return label
    }
}
