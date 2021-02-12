//
//  RestaurantDetailVCHeaderView.swift
//  GoodEats
//
//  Created by William Yeung on 2/9/21.
//

import UIKit

class RestaurantDetailVCHeaderView: UIView {
    // MARK: - Properties
    var restaurant: Restaurant? {
        didSet {
            guard let restaurant = restaurant else { return }
            nameLabel.text = restaurant.name
            typeLabel.text = restaurant.type
            restaurantImageView.image = UIImage(named: restaurant.image)
            heartImageView.isHidden = !restaurant.isCheckedIn ? true : false
        }
    }
    
    // MARK: - Views
    let restaurantImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    let dimmingView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.2)
        return view
    }()

    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Rubik-Medium", size: 35)
        label.textColor = .white
        label.numberOfLines = 0
        return label
    }()
    
    let typeLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = #colorLiteral(red: 0.9058823529, green: 0.2980392157, blue: 0.2352941176, alpha: 1)
        label.adjustsFontForContentSizeCategory = true
        label.font = UIFontMetrics(forTextStyle: .headline).scaledFont(for: UIFont(name: "Rubik-Regular", size: 13)!)
        label.textColor = .white
        label.textAlignment = .center
        label.layer.cornerRadius = 5
        label.layer.masksToBounds = true
        return label
    }()
    
    let heartImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.image = UIImage(named: "heart-tick")?.withRenderingMode(.alwaysTemplate)
        iv.tintColor = .white
        return iv
    }()
    
    let ratingImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI
    func configureUI() {
        layoutUI()
    }
    
    func layoutUI() {
        addSubviews(restaurantImageView, dimmingView, typeLabel, nameLabel, heartImageView, ratingImageView)
        
        restaurantImageView.anchor(top: topAnchor, right: rightAnchor, bottom: bottomAnchor, left: leftAnchor)
        dimmingView.anchor(top: topAnchor, right: rightAnchor, bottom: bottomAnchor, left: leftAnchor)
            
        typeLabel.anchor(bottom: bottomAnchor, left: leftAnchor, paddingBottom: 14, paddingLeft: 14)
        typeLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 20).isActive = true
        typeLabel.rightAnchor.constraint(lessThanOrEqualTo: rightAnchor, constant: -95).isActive = true

        nameLabel.anchor(bottom: typeLabel.topAnchor, left: typeLabel.leftAnchor, paddingBottom: 3)
        nameLabel.rightAnchor.constraint(lessThanOrEqualTo: rightAnchor, constant: -50).isActive = true
        
        heartImageView.setDimension(wConst: 15, hConst: 15)
        heartImageView.anchor(left: typeLabel.rightAnchor, paddingLeft: 8)
        heartImageView.center(to: typeLabel, by: .centerY)
        
        ratingImageView.setDimension(wConst: 52, hConst: 50)
        ratingImageView.anchor(right: rightAnchor, bottom: typeLabel.bottomAnchor, paddingRight: 10)
    }
}
