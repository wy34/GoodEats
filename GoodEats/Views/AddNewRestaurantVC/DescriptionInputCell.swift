//
//  DescriptionInputCell.swift
//  GoodEats
//
//  Created by William Yeung on 2/12/21.
//

import UIKit

class DescriptionInputCell: UITableViewCell {
    // MARK: - Properties
    static let reuseId = "DescriptionInputCell"
    
    // MARK: - Views
    let label: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        label.text = NSLocalizedString("DESCRIPTION", comment: "DESCRIPTION")
        label.textColor = .darkGray
        return label
    }()
    
    let textView: UITextView = {
        let tv = UITextView()
        tv.backgroundColor = #colorLiteral(red: 0.9425370097, green: 0.9603253007, blue: 0.9629049897, alpha: 1)
        tv.text = NSLocalizedString("A great restaurant to try out.", comment: "A great restaurant to try out.")
        tv.font = UIFont.preferredFont(forTextStyle: .body)
        tv.textContainerInset = UIEdgeInsets(top: 3, left: 10, bottom: 3, right: 10)
        return tv
    }()
    
    private lazy var inputStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [label, textView])
        stack.axis = .vertical
        stack.alignment = .fill
        stack.spacing = 15
        return stack
    }()
    
    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        layoutViews()
        textView.layer.cornerRadius = 5
        textView.layer.masksToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI
    func layoutViews() {
        contentView.addSubview(inputStack)
        textView.setDimension(height: heightAnchor, hMult: 0.6)
        inputStack.anchor(right: readableContentGuide.rightAnchor, left: readableContentGuide.leftAnchor, paddingRight: 2, paddingLeft: 2)
        inputStack.setDimension(height: heightAnchor, hMult: 0.8)
        inputStack.center(to: self, by: .centerY)
    }
}
