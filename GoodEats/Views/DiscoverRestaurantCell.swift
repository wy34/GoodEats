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
            typeLabel.text = cloudRestaurant.type
            locationDetailLabel.text = cloudRestaurant.location
            descriptionLabel.text = cloudRestaurant.summary
            phoneDetailLabel.text = cloudRestaurant.phone
            
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
        iv.layer.cornerRadius = 5
        iv.layer.masksToBounds = true
        return iv
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Moon Rock Cafe"
        label.numberOfLines = 0
        label.font = UIFontMetrics(forTextStyle: .body).scaledFont(for: UIFont.init(name: "Rubik-Medium", size: 25)!)
        return label
    }()
    
    private let typeLabelContainer: UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.9058823529, green: 0.2980392157, blue: 0.2352941176, alpha: 1)
        view.layer.cornerRadius = 5
        view.layer.masksToBounds = true
        return view
    }()
    
    private let typeLabel: UILabel = {
        let label = UILabel()
        label.text = "Cafe"
        label.adjustsFontForContentSizeCategory = true
        label.font = UIFontMetrics(forTextStyle: .headline).scaledFont(for: UIFont(name: "Rubik-Regular", size: 16)!)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    let locationIconImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.image = UIImage(systemName: "location")?.withRenderingMode(.alwaysTemplate)
        iv.tintColor = UIColor(named: "InvertedDarkMode")
        iv.clipsToBounds = true
        return iv
    }()
    
    let locationDetailLabel: UILabel = {
        let label = UILabel()
        label.adjustsFontForContentSizeCategory = true
        label.font = UIFontMetrics(forTextStyle: .headline).scaledFont(for: UIFont(name: "Rubik-Regular", size: 14)!)
        label.numberOfLines = 0
        label.text = "asldfkasjldkfas;df;asjdfjasd;f"
        label.textColor = UIColor(named: "DescriptionText")
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
        iv.image = UIImage(systemName: "phone")?.withRenderingMode(.alwaysTemplate)
        iv.tintColor = UIColor(named: "InvertedDarkMode")
        return iv
    }()
    
    let phoneDetailLabel: UILabel = {
        let label = UILabel()
        label.adjustsFontForContentSizeCategory = true
        label.font = UIFontMetrics(forTextStyle: .headline).scaledFont(for: UIFont(name: "Rubik-Regular", size: 14)!)
        label.numberOfLines = 0
        label.text = "lasfjlaskjdlakjsldfjas;dfj;"
        label.textColor = UIColor(named: "DescriptionText")
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
        label.textColor = UIColor(named: "DescriptionText")
        label.numberOfLines = 0
        return label
    }()
    
    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = UIColor(named: "DarkMode")
        layoutViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI
    func layoutViews() {
        addSubviews(restaurantImageView, nameLabel, typeLabelContainer, locationStack, phoneStack, descriptionLabel)

        restaurantImageView.anchor(top: topAnchor, right: readableContentGuide.rightAnchor, left: readableContentGuide.leftAnchor, paddingTop: 15)
        restaurantImageView.setDimension(hConst: 225)

        nameLabel.anchor(top: restaurantImageView.bottomAnchor, right: restaurantImageView.rightAnchor, left: restaurantImageView.leftAnchor, paddingTop: 5)
        
        typeLabelContainer.anchor(top: nameLabel.bottomAnchor, left: nameLabel.leftAnchor, paddingTop: 5)
        typeLabelContainer.heightAnchor.constraint(greaterThanOrEqualToConstant: 20).isActive = true
        typeLabelContainer.rightAnchor.constraint(lessThanOrEqualTo: rightAnchor, constant: -95).isActive = true
  
        typeLabelContainer.addSubview(typeLabel)
        typeLabel.anchor(top: typeLabelContainer.topAnchor, right: typeLabelContainer.rightAnchor, bottom: typeLabelContainer.bottomAnchor, left: typeLabelContainer.leftAnchor, paddingTop: 3, paddingRight: 5, paddingBottom: 3, paddingLeft: 5)

        locationIconImageView.setDimension(wConst: 20, hConst: 20)
        locationStack.anchor(top: typeLabelContainer.bottomAnchor, right: restaurantImageView.rightAnchor, left: restaurantImageView.leftAnchor, paddingTop: 5)

        phoneIconImageView.setDimension(wConst: 20, hConst: 20)
        phoneStack.anchor(top: locationStack.bottomAnchor, right: locationStack.rightAnchor, left: locationStack.leftAnchor, paddingTop: 5)

        descriptionLabel.anchor(top: phoneStack.bottomAnchor, right: phoneStack.rightAnchor, bottom: bottomAnchor, left: phoneStack.leftAnchor, paddingTop: 5, paddingBottom: 15)
    }
}
