//
//  DiscoverRestaurantCell.swift
//  GoodEats
//
//  Created by William Yeung on 2/18/21.
//

import UIKit
import CloudKit


class DiscoverRestaurantCell: UITableViewCell {
    // MARK: - Properties
    static let reuseId = "DiscoverRestaurantCell"
    
    let imageCache = NSCache<CKRecord.ID, CloudRestaurant>()
    
    var cloudRestaurant: CloudRestaurant? {
        didSet {
            guard let cloudRestaurant = cloudRestaurant else { return }
            nameLabel.text = cloudRestaurant.name
            
            if let restaurant = imageCache.object(forKey: cloudRestaurant.recordId!) {
                self.restaurantImageView.image = restaurant.image
            } else {
                self.restaurantImageView.image = cloudRestaurant.image
                self.imageCache.setObject(cloudRestaurant, forKey: cloudRestaurant.recordId!)
            }
        }
    }
    
    // MARK: - Views
    let restaurantImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.image = UIImage(systemName: "photo")
        iv.tintColor = .darkGray
        return iv
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Moon Rock Cafe"
        label.font = UIFontMetrics(forTextStyle: .body).scaledFont(for: UIFont.init(name: "Rubik-Medium", size: 25)!)
        return label
    }()
    
    private let typeLabel: UILabel = {
        let label = UILabel()
        label.text = "Cafe"
        label.font = UIFontMetrics(forTextStyle: .body).scaledFont(for: UIFont.init(name: "Rubik-Medium", size: 16)!)
        return label
    }()
    
    let locationIconImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.image = UIImage(systemName: "location")
        iv.tintColor = .black
        iv.clipsToBounds = true
        return iv
    }()
    
    let locationDetailLabel: UILabel = {
        let label = UILabel()
        label.adjustsFontForContentSizeCategory = true
        label.font = UIFontMetrics(forTextStyle: .headline).scaledFont(for: UIFont(name: "Rubik-Regular", size: 14)!)
        label.numberOfLines = 0
        label.text = "asldfkasjldkfas;df;asjdfjasd;f"
        label.textColor = .darkGray
        return label
    }()
    
    lazy var locationStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [locationIconImageView, locationDetailLabel])
        stack.spacing = 10
        stack.alignment = .center
        return stack
    }()
    
    let phoneIconImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.image = UIImage(systemName: "phone")
        iv.tintColor = .black
        return iv
    }()
    
    let phoneDetailLabel: UILabel = {
        let label = UILabel()
        label.adjustsFontForContentSizeCategory = true
        label.font = UIFontMetrics(forTextStyle: .headline).scaledFont(for: UIFont(name: "Rubik-Regular", size: 14)!)
        label.numberOfLines = 0
        label.text = "lasfjlaskjdlakjsldfjas;dfj;"
        label.textColor = .darkGray
        return label
    }()
    
    lazy var phoneStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [phoneIconImageView, phoneDetailLabel])
        stack.spacing = 10
        stack.alignment = .center
        return stack
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFontMetrics(forTextStyle: .headline).scaledFont(for: UIFont(name: "Rubik-Regular", size: 14)!)
        label.text = "lasfjlaskjdlakjsldfjaslasfjlaskjdlakjsldfjas;dfj;lasfjlaskjdlakjsldf"
        label.textColor = .darkGray
        label.numberOfLines = 0
        return label
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
        addSubviews(restaurantImageView, nameLabel, typeLabel, locationStack, phoneStack, descriptionLabel)

        restaurantImageView.anchor(top: topAnchor, right: readableContentGuide.rightAnchor, left: readableContentGuide.leftAnchor, paddingTop: 15)
        restaurantImageView.setDimension(hConst: 225)

        nameLabel.anchor(top: restaurantImageView.bottomAnchor, right: restaurantImageView.rightAnchor, left: restaurantImageView.leftAnchor, paddingTop: 5)
        typeLabel.anchor(top: nameLabel.bottomAnchor, right: nameLabel.rightAnchor, left: nameLabel.leftAnchor)

        locationIconImageView.setDimension(wConst: 20, hConst: 20)
        locationStack.anchor(top: typeLabel.bottomAnchor, right: typeLabel.rightAnchor, left: typeLabel.leftAnchor, paddingTop: 5)

        phoneIconImageView.setDimension(wConst: 20, hConst: 20)
        phoneStack.anchor(top: locationStack.bottomAnchor, right: locationStack.rightAnchor, left: locationStack.leftAnchor, paddingTop: 5)

        descriptionLabel.anchor(top: phoneStack.bottomAnchor, right: phoneStack.rightAnchor, bottom: bottomAnchor, left: phoneStack.leftAnchor, paddingTop: 5, paddingBottom: 15)
    }
}
