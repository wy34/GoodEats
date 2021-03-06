//
//  NameInputCell.swift
//  GoodEats
//
//  Created by William Yeung on 2/12/21.
//

import UIKit

class NameInputCell: BasicInputCell {
    // MARK: - Properties
    static let reuseId = "NameInputCell"
    
    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        label.text = NSLocalizedString("NAME", comment: "NAME")
        textField.placeholder = NSLocalizedString("Fill in your restaurant name.", comment: "Fill in your restaurant name.")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
