//
//  NewRestaurantImageCell.swift
//  GoodEats
//
//  Created by William Yeung on 2/11/21.
//

import UIKit

class NewRestaurantImageCell: UITableViewCell {
    // MARK: - Properties
    static let reuseId = "NewRestaurantImageCell"
    
    // MARK: - Views
    let placeholderImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        iv.tintColor = UIColor(named: "InvertedDarkMode")
        iv.image = UIImage(systemName: "photo")?.withRenderingMode(.alwaysTemplate)
        return iv
    }()
    
    let restaurantImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        iv.tintColor = .black
        return iv
    }()
    
    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = UIColor(named: "AboutCell")
        layoutViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI
    func layoutViews() {
        addSubviews(placeholderImageView, restaurantImageView)
        
        placeholderImageView.setDimension(wConst: 25, hConst: 25)
        placeholderImageView.center(x: self.centerXAnchor, y: self.centerYAnchor)
        restaurantImageView.anchor(top: topAnchor, right: rightAnchor, bottom: bottomAnchor, left: leftAnchor)
    }
}
