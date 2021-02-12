//
//  AddressInputCell.swift
//  GoodEats
//
//  Created by William Yeung on 2/12/21.
//

import UIKit

class AddressInputCell: BasicInputCell {
    // MARK: - Properties
    static let reuseId = "AddressInputCell"
    
    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        label.text = "ADDRESS"
        textField.placeholder = "Fill in your restaurant address."
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
