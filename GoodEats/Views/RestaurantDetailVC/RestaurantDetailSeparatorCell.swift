//
//  RestaurantDetailSeparatorCell.swift
//  GoodEats
//
//  Created by William Yeung on 2/10/21.
//

import UIKit

class RestaurantDetailSeparatorCell: UITableViewCell {
    // MARK: - Properties
    static let reuseId = "RestaurantDetailSeparatorCell"
    
    // MARK: - Views
    private let subSectionLabel = UILabel.createLabel(text: "HOW TO GET HERE", textColor: UIColor(named: "InvertedDarkMode")!, textStyle: .headline)
    
    private let separator: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        return view
    }()
    
    private lazy var headerStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [subSectionLabel, separator])
        stack.axis = .vertical
        stack.spacing = 5
        stack.alignment = .fill
        return stack
    }()
    
    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        layoutViews()
        backgroundColor = UIColor(named: "DarkMode")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI
    func layoutViews() {
        addSubview(headerStack)
        
        separator.setDimension(hConst: 1)
        headerStack.anchor(top: topAnchor, right: rightAnchor, bottom: bottomAnchor, left: leftAnchor, paddingTop: 5, paddingRight: 18, paddingBottom: 12, paddingLeft: 18)
    }
}
