//
//  OnboardingCell.swift
//  GoodEats
//
//  Created by William Yeung on 2/16/21.
//

import UIKit

class OnboardingCell: UICollectionViewCell {
    // MARK: - Properties
    var onboarding: Onboarding? {
        didSet {
            guard let onboarding = onboarding else { return }
            imageView.image = UIImage(named: onboarding.image)
            headlineLabel.text = onboarding.headline
            subHeadlineLabel.text = onboarding.subHeadline
        }
    }
    
    static let reuseId = "OnboardingCell"
    
    // MARK: - Views
    private let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    let headlineLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.adjustsFontForContentSizeCategory = true
        label.font = UIFontMetrics(forTextStyle: .headline).scaledFont(for: UIFont(name: "Rubik", size: 17)!)
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.textColor = .darkGray
        label.numberOfLines = 2
        return label
    }()
    
    private let subHeadlineLabel: UILabel = {
        let label = UILabel()
        label.font = UIFontMetrics(forTextStyle: .headline).scaledFont(for: UIFont(name: "Rubik", size: 16)!)
        label.textColor = .lightGray
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
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
        addSubviews(imageView, headlineLabel, subHeadlineLabel)
        
        imageView.anchor(right: rightAnchor, left: leftAnchor)
        imageView.center(to: self, by: .centerY, withMultiplierOf: 0.8)
        imageView.setDimension(height: heightAnchor, hMult: 0.45)
        
        headlineLabel.anchor(top: imageView.bottomAnchor, paddingTop: 20)
        headlineLabel.center(to: imageView, by: .centerX)
        headlineLabel.setDimension(width: widthAnchor, wMult: 0.95)
        subHeadlineLabel.anchor(top: headlineLabel.bottomAnchor, paddingTop: 10)
        subHeadlineLabel.center(to: headlineLabel, by: .centerX)
        subHeadlineLabel.setDimension(width: widthAnchor, wMult: 0.9)
    }
}
