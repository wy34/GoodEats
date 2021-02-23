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
        let label = UILabel.createLabel(textColor: UIColor(named: "DescriptionText")!, fontName: "Rubik-Light", textStyle: .headline, fontSize: 15, alignment: .left)
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
