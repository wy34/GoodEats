//
//  RestaurantTableViewCell.swift
//  GoodEats
//
//  Created by William Yeung on 2/8/21.
//

import UIKit

class RestaurantTableViewCell: UITableViewCell {
    // MARK: - Properties
    static let reuseId = "RestuarantTableViewCell"
    
    var restaurant: Restaurant? {
        didSet {
            guard let restaurant = restaurant else { return }
            thumbnailImageView.image = UIImage(named: restaurant.image)
            nameLabel.text = restaurant.name
            locationLabel.text = restaurant.location
            typeLabel.text = restaurant.type
        }
    }
    
    // MARK: - Views
    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Name"
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        return label
    }()
    
    let locationLabel: UILabel = {
        let label = UILabel()
        label.text = "Location"
        label.font = UIFont.preferredFont(forTextStyle: .subheadline)
        label.textColor = .darkGray
        label.numberOfLines = 2
        return label
    }()
    
    private let typeLabel: UILabel = {
        let label = UILabel()
        label.text = "Type"
        label.font = UIFont.preferredFont(forTextStyle: .subheadline)
        label.textColor = .darkGray
        return label
    }()
    
    let thumbnailImageView: UIImageView = {
        let iv = UIImageView()
        iv.layer.cornerRadius = 30
        iv.clipsToBounds = true
        return iv
    }()
    
    private lazy var labelStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [nameLabel, locationLabel, typeLabel])
        stack.axis = .vertical
        stack.spacing = 1
        return stack
    }()
    
    private lazy var imageLabelStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [thumbnailImageView, labelStack])
        stack.axis = .horizontal
        stack.spacing = 15
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
        addSubview(imageLabelStack)
        
        thumbnailImageView.setDimension(wConst: 60, hConst: 60)
        imageLabelStack.anchor(right: rightAnchor, left: readableContentGuide.leftAnchor, paddingRight: 15)
        imageLabelStack.center(to: self, by: .centerY)
    }
}
