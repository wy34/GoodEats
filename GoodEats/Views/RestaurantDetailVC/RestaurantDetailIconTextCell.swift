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
    
    let detailLabel: UILabel = {
        let label = UILabel()
        label.adjustsFontForContentSizeCategory = true
        label.font = UIFontMetrics(forTextStyle: .headline).scaledFont(for: UIFont(name: "Rubik-Regular", size: 14)!)
        label.numberOfLines = 0
        return label
    }()
    
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
            iconImageView.image = UIImage(systemName: "phone")?.withTintColor(.black, renderingMode: .alwaysOriginal)
            detailLabel.text = restaurant.phone
        } else {
            iconImageView.image = UIImage(systemName: "map")?.withTintColor(.black, renderingMode: .alwaysOriginal)
            detailLabel.text = restaurant.location
        }
    }
}
