//
//  BasicInputCell.swift
//  GoodEats
//
//  Created by William Yeung on 2/11/21.
//

import UIKit

class BasicInputCell: UITableViewCell {
    // MARK: - Views
    let label: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        label.textColor = .darkGray
        return label
    }()
    
    let textField: PaddedTextField = {
        let tf = PaddedTextField()
        tf.backgroundColor = #colorLiteral(red: 0.9425370097, green: 0.9603253007, blue: 0.9629049897, alpha: 1)
        tf.font = UIFont.preferredFont(forTextStyle: .body)
        return tf
    }()
    
    private lazy var inputStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [label, textField])
        stack.axis = .vertical
        stack.alignment = .fill
        stack.distribution = .fillEqually
        stack.spacing = 5
        return stack
    }()
    
    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        layoutViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI
    func layoutViews() {
        contentView.addSubview(inputStack)
        inputStack.anchor(right: readableContentGuide.rightAnchor, left: readableContentGuide.leftAnchor, paddingRight: 2, paddingLeft: 2)
        inputStack.setDimension(height: heightAnchor, hMult: 0.8)
        inputStack.center(to: self, by: .centerY)
    }
}
