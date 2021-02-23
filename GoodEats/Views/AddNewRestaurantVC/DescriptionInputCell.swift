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
    let label = UILabel.createLabel(text: "DESCRIPTION", textColor: .darkGray, textStyle: .headline)
    
    let placeholderLabel = UILabel.createLabel(text: "A great restaurant to try out.", textColor: UIColor(named: "Placeholder")!, textStyle: .body)
    
    lazy var textView: UITextView = {
        let tv = UITextView()
        tv.backgroundColor = UIColor(named: "AboutCell")
        tv.font = UIFont.preferredFont(forTextStyle: .body)
        tv.textContainerInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 10)
        tv.delegate = self
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
        backgroundColor = UIColor(named: "DarkMode")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI
    func layoutViews() {
        contentView.addSubviews(inputStack, placeholderLabel)
        textView.setDimension(height: heightAnchor, hMult: 0.6)
        inputStack.anchor(right: readableContentGuide.rightAnchor, left: readableContentGuide.leftAnchor, paddingRight: 2, paddingLeft: 2)
        inputStack.setDimension(height: heightAnchor, hMult: 0.8)
        inputStack.center(to: self, by: .centerY)
        placeholderLabel.anchor(top: textView.topAnchor, left: textView.leftAnchor, paddingTop: 5, paddingLeft: 10)
    }
}

extension DescriptionInputCell: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        placeholderLabel.isHidden = !textView.text.isEmpty
    }
}
