//
//  RestaurantDetailTextCell.swift
//  GoodEats
//
//  Created by William Yeung on 2/9/21.
//

import UIKit

class RestaurantDetailTextCell: UITableViewCell {
    // MARK: - Properties
    static let reuseId = "RestaurantDetailTextCell"
    
    // MARK: - Views
    let detailLabel: UILabel = {
        let label = UILabel()
        label.adjustsFontForContentSizeCategory = true
        label.font = UIFontMetrics(forTextStyle: .headline).scaledFont(for: UIFont(name: "Rubik-Light", size: 15)!)
        label.textColor = UIColor(named: "DescriptionText")
        label.numberOfLines = 0
        return label
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
        addSubviews(detailLabel)
        detailLabel.anchor(top: topAnchor, right: rightAnchor, bottom: bottomAnchor, left: leftAnchor, paddingTop: 15, paddingRight: 20, paddingBottom: 15, paddingLeft: 20)
    }
    
    func populateDataIntoViews(fromRestaurant restaurant: Restaurant?) {
        guard let restaurant = restaurant else { return }
        detailLabel.text = restaurant.summary
    }
}
