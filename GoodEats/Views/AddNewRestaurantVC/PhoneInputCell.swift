//
//  PhoneInputCell.swift
//  GoodEats
//
//  Created by William Yeung on 2/12/21.
//

import UIKit

class PhoneInputCell: BasicInputCell {
    // MARK: - Properties
    static let reuseId = "PhoneInputCell"
    
    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        label.text = "PHONE"
        textField.placeholder = "Fill in your restaurant phone."
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
