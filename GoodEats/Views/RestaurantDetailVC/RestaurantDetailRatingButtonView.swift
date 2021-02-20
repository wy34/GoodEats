//
//  RestaurantDetailRatingView.swift
//  GoodEats
//
//  Created by William Yeung on 2/11/21.
//

import UIKit

protocol RestaurantDetailRatingViewDelegate: class {
    func presentRatingVC()
}

class RestaurantDetailRatingButtonView: UIView {
    // MARK: - Properties
    weak var delegate: RestaurantDetailRatingViewDelegate?
    
    // MARK: - Views
    private let rateButton: UIButton = {
        let button = UIButton(type: .system)
        button.titleLabel?.font = UIFont.preferredFont(forTextStyle: .headline)
        button.setTitle(NSLocalizedString("Rate It", comment: "Rate It"), for: .normal)
        button.backgroundColor = #colorLiteral(red: 0.9058823529, green: 0.2980392157, blue: 0.2352941176, alpha: 1)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 25
        button.addTarget(self, action: #selector(handleRateButtonTapped), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        layoutViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI
    func layoutViews() {
        addSubview(rateButton)
        rateButton.setDimension(wConst: 345, hConst: 47)
        rateButton.anchor(right: rightAnchor, bottom: bottomAnchor, left: leftAnchor, paddingRight: 15, paddingBottom: 21, paddingLeft: 15)
    }
    
    // MARK: - Selector
    @objc func handleRateButtonTapped() {
        delegate?.presentRatingVC()
    }
}
