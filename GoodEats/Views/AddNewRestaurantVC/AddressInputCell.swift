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
        label.text = NSLocalizedString("ADDRESS", comment: "ADDRESS")
        textField.placeholder = NSLocalizedString("Fill in your restaurant address.", comment: "Fill in your restaurant address.")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
