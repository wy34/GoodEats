//
//  PaddedLabel.swift
//  GoodEats
//
//  Created by William Yeung on 2/21/21.
//

import UIKit

class PaddedLabel: UILabel {
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
    
    override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        super.drawText(in: rect.inset(by: edgeInsets))
    }
    
    var edgeInsets: UIEdgeInsets = .zero
    
    override func textRect(forBounds bounds: CGRect, limitedToNumberOfLines numberOfLines: Int) -> CGRect {
        var rect = super.textRect(forBounds: bounds.inset(by: edgeInsets), limitedToNumberOfLines: numberOfLines)

        rect.origin.x -= edgeInsets.left
        rect.origin.y -= edgeInsets.top
        rect.size.width  += (edgeInsets.left + edgeInsets.right);
        rect.size.height += (edgeInsets.top + edgeInsets.bottom);

        return rect
    }

//        override func textRectForBounds(bounds: CGRect, limitedToNumberOfLines numberOfLines: Int) -> CGRect {
//            var rect = super.textRectForBounds(UIEdgeInsetsInsetRect(bounds, edgeInsets), limitedToNumberOfLines: numberOfLines)
//
//            rect.origin.x -= edgeInsets.left
//            rect.origin.y -= edgeInsets.top
//            rect.size.width  += (edgeInsets.left + edgeInsets.right);
//            rect.size.height += (edgeInsets.top + edgeInsets.bottom);
//
//            return rect
//        }
//
//        override func drawTextInRect(rect: CGRect) {
//            super.drawTextInRect(UIEdgeInsetsInsetRect(rect, edgeInsets))
//        }
}
