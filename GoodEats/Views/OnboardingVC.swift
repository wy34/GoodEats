//
//  OnboardingVC.swift
//  GoodEats
//
//  Created by William Yeung on 2/15/21.
//

import UIKit

class OnboardingVC: UIViewController {
    // MARK: - Properties
    
    
    // MARK: - Views
    private let containerView = UIView()
    
    private let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.image = UIImage(named: "onboarding-1")
        return iv
    }()
    
    private let headlineLabel: UILabel = {
        let label = UILabel()
        label.text = "Create your own food guide".uppercased()
        label.textAlignment = .center
        label.adjustsFontForContentSizeCategory = true
        label.font = UIFontMetrics(forTextStyle: .headline).scaledFont(for: UIFont(name: "Rubik", size: 17)!)
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.textColor = .darkGray
        return label
    }()
    
    private let subHeadlineLabel: UILabel = {
        let label = UILabel()
        label.text = "Pin your favorite restaurants and create your own food guide."
        label.font = UIFontMetrics(forTextStyle: .headline).scaledFont(for: UIFont(name: "Rubik", size: 16)!)
        label.textColor = .lightGray
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private let nextButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("NEXT", for: .normal)
        button.backgroundColor = #colorLiteral(red: 0.9058823529, green: 0.2980392157, blue: 0.2352941176, alpha: 1)
        button.layer.cornerRadius = 25
        button.layer.masksToBounds = true
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.preferredFont(forTextStyle: .subheadline)
        return button
    }()
    
    private let skipButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Skip", for: .normal)
        button.backgroundColor = .clear
        button.setTitleColor(.darkGray, for: .normal)
        button.titleLabel?.font = UIFont.preferredFont(forTextStyle: .body)
        return button
    }()
    
    private let pageControl: UIPageControl = {
        let pc = UIPageControl()
        pc.numberOfPages = 3
        pc.currentPage = 0
        pc.currentPageIndicatorTintColor = #colorLiteral(red: 0.9058823529, green: 0.2980392157, blue: 0.2352941176, alpha: 1)
        pc.pageIndicatorTintColor = .lightGray
        return pc
    }()
    
    private lazy var controlStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [pageControl, nextButton, skipButton])
        stack.axis = .vertical
        stack.distribution = .fillEqually
        stack.spacing = 15
        return stack
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        layoutViews()
    }
    
    // MARK: - UI
    func layoutViews() {
        view.addSubviews(containerView, controlStack)

        containerView.anchor(top: view.topAnchor, right: view.rightAnchor, left: view.leftAnchor)
        containerView.setDimension(height: view.heightAnchor, hMult: 0.666)
        
        containerView.addSubviews(imageView, headlineLabel, subHeadlineLabel)
        
        imageView.anchor(right: containerView.rightAnchor, left: containerView.leftAnchor)
        imageView.center(to: containerView, by: .centerY, withMultiplierOf: 0.65)
        imageView.setDimension(height: containerView.heightAnchor, hMult: 0.45)
        
        headlineLabel.anchor(top: imageView.bottomAnchor, paddingTop: 30)
        headlineLabel.center(to: imageView, by: .centerX)
        subHeadlineLabel.anchor(top: headlineLabel.bottomAnchor, paddingTop: 10)
        subHeadlineLabel.center(to: headlineLabel, by: .centerX)
        subHeadlineLabel.setDimension(width: containerView.widthAnchor, wMult: 0.9)
        
        nextButton.setDimension(wConst: 190, hConst: 50)
        controlStack.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor)
        controlStack.center(to: view, by: .centerX)
    }
}
