//
//  RestaurantDetailViewController.swift
//  GoodEats
//
//  Created by William Yeung on 2/9/21.
//

import UIKit

class RestaurantDetailViewController: UIViewController {
    // MARK: - Properties
    var restaurant: Restaurant? {
        didSet {
            guard let restaurant = restaurant else { return }
            restaurantImageView.image = UIImage(named: restaurant.image)
            nameLabel.text = restaurant.name
            locationLabel.text = restaurant.location
            typeLabel.text = restaurant.type
        }
    }
    
    // MARK: - Views
    let restaurantImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    let locationLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .subheadline)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    private let typeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .subheadline)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    private lazy var labelStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [nameLabel, typeLabel, locationLabel])
        stack.axis = .vertical
        stack.spacing = 1
        return stack
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    // MARK: - UI
    func configureUI() {
        navigationItem.largeTitleDisplayMode = .never
        layoutViews()
    }
    
    func layoutViews() {
        view.addSubviews(restaurantImageView, labelStack)
        restaurantImageView.anchor(top: view.topAnchor, right: view.rightAnchor, bottom: view.bottomAnchor, left: view.leftAnchor)
        labelStack.center(x: view.centerXAnchor, y: view.centerYAnchor)
    }
}
