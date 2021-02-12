//
//  NameInputCell.swift
//  GoodEats
//
//  Created by William Yeung on 2/12/21.
//

import UIKit

class TypeInputCell: BasicInputCell {
    // MARK: - Properties
    static let reuseId = "TypeInputCell"
    
    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        label.text = "TYPE"
        textField.placeholder = "Fill in your restaurant type."
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
