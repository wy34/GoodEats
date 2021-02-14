//
//  RatingVC.swift
//  GoodEats
//
//  Created by William Yeung on 2/11/21.
//

import UIKit

class RatingVC: UIViewController {
    // MARK: - Properties
    var restaurant: Restaurant? {
        didSet {
            guard let restaurant = restaurant else { return }
            backgroundImageView.image = UIImage(data: restaurant.image ?? Data())

            // Applying the blur effect
            let blurEffect = UIBlurEffect(style: .dark)
            let blurEffectView = UIVisualEffectView(effect: blurEffect)
            blurEffectView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
            backgroundImageView.addSubview(blurEffectView)
        }
    }
    
    var restaurantDetailVC: RestaurantDetailVC?
    
    // MARK: - Views
    private lazy var backgroundImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    private let closeButton: UIButton = {
        let button = UIButton(type: .system)
        let sizeConfig = UIImage.SymbolConfiguration(pointSize: 30)
        button.setImage(UIImage(systemName: "xmark")?.withConfiguration(sizeConfig), for: .normal)
        button.tintColor = .white
        button.transform = CGAffineTransform(translationX: 0, y: -100)
        button.addTarget(self, action: #selector(handleCloseTapped), for: .touchUpInside)
        return button
    }()
    
    private let loveButton = UIButton.createRatingButton(withImage: "love", andTitle: "Love")
    private let coolButton = UIButton.createRatingButton(withImage: "cool", andTitle: "Cool")
    private let happyButton = UIButton.createRatingButton(withImage: "happy", andTitle: "Happy")
    private let sadButton = UIButton.createRatingButton(withImage: "sad", andTitle: "Sad")
    private let angryButton = UIButton.createRatingButton(withImage: "angry", andTitle: "Angry")
    
    private lazy var buttonStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [loveButton, coolButton, happyButton, sadButton, angryButton])
        stack.axis = .vertical
        stack.alignment = .leading
        stack.spacing = 10
        return stack
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        layoutViews()
        addTargetsToRatingButtons()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        slideInButtonsOnAppear()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - UI
    func layoutViews() {
        view.addSubviews(backgroundImageView, closeButton, buttonStack)
        backgroundImageView.anchor(top: view.topAnchor, right: view.rightAnchor, bottom: view.bottomAnchor, left: view.leftAnchor)
        closeButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, right: view.rightAnchor, paddingTop: 10, paddingRight: 26)
        buttonStack.center(x: view.centerXAnchor, y: view.centerYAnchor)
        
        for button in buttonStack.subviews {
            button.transform = CGAffineTransform(translationX: 600, y: 0)
        }
    }
    
    func addTargetsToRatingButtons() {
        for view in buttonStack.subviews {
            guard let button = view as? UIButton else { return }
            button.addTarget(self, action: #selector(handleRatingButtonTapped(sender:)), for: .touchUpInside)
        }
    }
    
    // MARK: - Animations
    func fadeInButtonsOnAppear() {
        var delay = 0.1
        
        for button in buttonStack.subviews {
            UIView.animate(withDuration: 0.4, delay: delay, options: []) {
                button.alpha = 1
            }
            delay += 0.05
        }
    }
    
    func slideInButtonsOnAppear() {
        var delay = 0.1
        
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.65, initialSpringVelocity: 0.25, options: []) {
            self.closeButton.transform = .identity
        }

        for button in buttonStack.subviews {
            UIView.animate(withDuration: 0.75, delay: delay, usingSpringWithDamping: 0.65, initialSpringVelocity: 0.25, options: []) {
                button.transform = .identity
            }
            delay += 0.05
        }
    }
    
    // MARK: - Selector
    @objc func handleCloseTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func handleRatingButtonTapped(sender: UIButton) {
        dismiss(animated: true) {
            guard let restaurantDetailVC = self.restaurantDetailVC else { return }
            restaurantDetailVC.configureRatingImageView(withImage: sender.titleLabel?.text?.lowercased())
        }
    }
}
