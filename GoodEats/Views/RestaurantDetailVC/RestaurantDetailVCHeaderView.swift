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
            restaurantImageView.image = UIImage(data: restaurant.image ?? Data())
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
    
    private let typeLabelContainer: UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.9058823529, green: 0.2980392157, blue: 0.2352941176, alpha: 1)
        view.layer.cornerRadius = 5
        view.layer.masksToBounds = true
        return view
    }()
    
    private let typeLabel = UILabel.createLabel(textColor: .white, fontName: "Rubik-Regular", textStyle: .headline, fontSize: 13, alignment: .center)
    
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
        backgroundColor = UIColor(named: "DarkMode")
    }
    
    func layoutUI() {
        addSubviews(restaurantImageView, dimmingView, typeLabelContainer, nameLabel, heartImageView, ratingImageView)
        
        restaurantImageView.anchor(top: topAnchor, right: rightAnchor, bottom: bottomAnchor, left: leftAnchor)
        dimmingView.anchor(top: topAnchor, right: rightAnchor, bottom: bottomAnchor, left: leftAnchor)
        
        typeLabelContainer.anchor(bottom: bottomAnchor, left: leftAnchor, paddingBottom: 14, paddingLeft: 14)
        typeLabelContainer.heightAnchor.constraint(greaterThanOrEqualToConstant: 20).isActive = true
        typeLabelContainer.rightAnchor.constraint(lessThanOrEqualTo: rightAnchor, constant: -95).isActive = true
  
        typeLabelContainer.addSubview(typeLabel)
        typeLabel.anchor(top: typeLabelContainer.topAnchor, right: typeLabelContainer.rightAnchor, bottom: typeLabelContainer.bottomAnchor, left: typeLabelContainer.leftAnchor, paddingTop: 3, paddingRight: 5, paddingBottom: 3, paddingLeft: 5)

        nameLabel.anchor(bottom: typeLabelContainer.topAnchor, left: typeLabelContainer.leftAnchor, paddingBottom: 3)
        nameLabel.rightAnchor.constraint(lessThanOrEqualTo: rightAnchor, constant: -50).isActive = true
        
        heartImageView.setDimension(wConst: 15, hConst: 15)
        heartImageView.anchor(left: typeLabelContainer.rightAnchor, paddingLeft: 8)
        heartImageView.center(to: typeLabelContainer, by: .centerY)
        
        ratingImageView.setDimension(wConst: 52, hConst: 50)
        ratingImageView.anchor(right: rightAnchor, bottom: typeLabelContainer.bottomAnchor, paddingRight: 10)
    }
}
