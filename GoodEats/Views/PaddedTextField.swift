//
//  PaddedTextField.swift
//  GoodEats
//
//  Created by William Yeung on 2/12/21.
//

import UIKit

class PaddedTextField: UITextField {
    // MARK: - Properties
    let padding = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.cornerRadius = 5
        layer.masksToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Padding Methods
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
}
