//
//  WelcomeAlertView.swift
//  GoodEats
//
//  Created by William Yeung on 2/25/21.
//

import UIKit

protocol WelcomeAlertViewDelegate: class {
    func dismissWelcomeAlert()
}

class WelcomeAlertView: UIView {
    // MARK: - Properties
    weak var delegate: WelcomeAlertViewDelegate?
    
    // MARK: - Views
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "WelcomeAlert")
        view.layer.cornerRadius = 15
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel.createLabel(textColor: UIColor.init(red: 231, green: 76, blue: 60), fontName: "Courgette-Regular", textStyle: .body, fontSize: 35, alignment: .center)
        label.text = NSLocalizedString("Hello Foodies!", comment: "Hello Foodies!")
        return label
    }()
    
    private let messageLabel: UILabel = {
        let label = UILabel.createLabel(textColor: UIColor(named: "InvertedDarkMode")!, fontName: "Rubik-Medium", textStyle: .body, fontSize: 18, alignment: .center)
        label.text = NSLocalizedString("Welcome to GoodEats! All the restaurants that you, as well as, all other users have shared, will show up here in real time.", comment: "Welcome to GoodEats! All the restaurants that you, as well as, all other users have shared, will show up here in real time.")
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var dismissButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.tintColor = UIColor(named: "DarkMode")
        button.backgroundColor = UIColor(named: "InvertedDarkMode")
        button.layer.cornerRadius = 30/2
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(handleDismissTapped), for: .touchUpInside)
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
        addSubviews(containerView)
        
        containerView.center(x: centerXAnchor, y: centerYAnchor)
        containerView.widthAnchor.constraint(lessThanOrEqualToConstant: 290).isActive = true
        containerView.heightAnchor.constraint(greaterThanOrEqualToConstant: 200).isActive = true
        
        containerView.addSubviews(titleLabel, messageLabel, dismissButton)
        
        titleLabel.center(to: containerView, by: .centerX)
        titleLabel.anchor(top: containerView.topAnchor, right: containerView.rightAnchor, left: containerView.leftAnchor, paddingTop: 20, paddingRight: 18, paddingLeft: 18)
        titleLabel.heightAnchor.constraint(greaterThanOrEqualTo: containerView.heightAnchor, multiplier: 0.2).isActive = true
        
        messageLabel.anchor(top: titleLabel.bottomAnchor, right: titleLabel.rightAnchor, bottom: containerView.bottomAnchor, left: titleLabel.leftAnchor, paddingTop: 5, paddingBottom: 18)
        messageLabel.center(to: self, by: .centerX)
        
        dismissButton.anchor(top: containerView.topAnchor, right: containerView.rightAnchor, paddingTop: -10, paddingRight: -10)
        dismissButton.setDimension(wConst: 30, hConst: 30)
    }
    
    // MARK: - Selector
    @objc func handleDismissTapped() {
        delegate?.dismissWelcomeAlert()
    }
}
