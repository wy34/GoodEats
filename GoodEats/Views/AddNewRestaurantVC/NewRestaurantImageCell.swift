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
    private let restaurantImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.image = UIImage(systemName: "photo")
        return iv
    }()
    
    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = #colorLiteral(red: 0.9425370097, green: 0.9603253007, blue: 0.9629049897, alpha: 1)
        layoutViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI
    func layoutViews() {
        addSubviews(restaurantImageView)
        restaurantImageView.setDimension(wConst: 24, hConst: 18)
        restaurantImageView.center(x: centerXAnchor, y: centerYAnchor)
    }
}
