//
//  RestaurantDetailIconCell.swift
//  GoodEats
//
//  Created by William Yeung on 2/9/21.
//

import UIKit

class RestaurantDetailIconTextCell: UITableViewCell {
    // MARK: - Properties
    static let reuseId = "RestaurantDetailIconTextCell"
    
    // MARK: - Views
    let iconImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    let detailLabel = UILabel.createLabel(textColor: UIColor(named: "DescriptionText")!, fontName: "Rubik-Regular", textStyle: .headline, fontSize: 14, alignment: .left)
    
    lazy var iconLabelStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [iconImageView, detailLabel])
        stack.spacing = 10
        stack.alignment = .center
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
        addSubviews(iconLabelStack)
        
        iconImageView.setDimension(wConst: 20, hConst: 20)
        iconLabelStack.anchor(top: topAnchor, right: rightAnchor, bottom: bottomAnchor, left: leftAnchor, paddingTop: 15, paddingRight: 20, paddingBottom: 15, paddingLeft: 20)
    }
    
    func populateDataIntoViews(fromRestaurant restaurant: Restaurant?, forPhone: Bool) {
        guard let restaurant = restaurant else { return }
        if forPhone {
            iconImageView.image = UIImage(systemName: "phone")?.withTintColor(UIColor(named: "InvertedDarkMode")!, renderingMode: .alwaysOriginal)
            detailLabel.text = restaurant.phone
        } else {
            iconImageView.image = UIImage(systemName: "map")?.withTintColor(UIColor(named: "InvertedDarkMode")!, renderingMode: .alwaysOriginal)
            detailLabel.text = restaurant.location
        }
    }
}
