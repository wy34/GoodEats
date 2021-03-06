//
//  WalkThruVC.swift
//  GoodEats
//
//  Created by William Yeung on 2/16/21.
//

import UIKit

class WalkThruVC: UICollectionViewController {
    // MARK: - Properties
    var onboardingObjs = [
        Onboarding(image: "onboarding-1", headline: NSLocalizedString("CREATE YOUR OWN FOOD GUIDE", comment: "CREATE YOUR OWN FOOD GUIDE"), subHeadline: NSLocalizedString("Pin your favorite restaurants and create your own food guide", comment: "Pin your favorite restaurants and create your own food guide")),
        Onboarding(image: "onboarding-2", headline: NSLocalizedString("SHOW YOU THE LOCATION", comment: "SHOW YOU THE LOCATION"), subHeadline: NSLocalizedString("Search and locate your favorite restaurant on Maps", comment: "Search and locate your favorite restaurant on Maps")),
        Onboarding(image: "onboarding-3", headline: NSLocalizedString("DISCOVER GREAT RESTAURANTS", comment: "DISCOVER GREAT RESTAURANTS"), subHeadline: NSLocalizedString("Find restaurants shared by your friends and other foodies", comment: "Find restaurants shared by your friends and other foodies"))
    ]
    
    // MARK: - Views
    private let controlsContainerView = UIView()
    
    private lazy var nextButton: UIButton = {
        let button = UIButton.createOnboardingVCButtons(title: "NEXT", titleColor: .white, bgColor: #colorLiteral(red: 0.9058823529, green: 0.2980392157, blue: 0.2352941176, alpha: 1), textStyle: .subheadline)
        button.layer.cornerRadius = 25
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(handleNextButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var skipButton: UIButton = {
        let button = UIButton.createOnboardingVCButtons(title: "Skip", titleColor: .darkGray, bgColor: .clear, textStyle: .body)
        button.addTarget(self, action: #selector(handleSkipButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let pageControl: UIPageControl = {
        let pc = UIPageControl()
        pc.numberOfPages = 3
        pc.currentPage = 0
        pc.currentPageIndicatorTintColor = #colorLiteral(red: 0.9058823529, green: 0.2980392157, blue: 0.2352941176, alpha: 1)
        pc.pageIndicatorTintColor = .lightGray
        pc.addTarget(self, action: #selector(handlePageControlTapped), for: .valueChanged)
        return pc
    }()
    
    private lazy var controlStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [pageControl, nextButton, skipButton])
        stack.axis = .vertical
        stack.distribution = .fillEqually
        stack.spacing = 10
        return stack
    }()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        layoutViews()
        setupCollectionView()
        presentationController?.delegate = self // for the viewControllerDidDismiss delegate
    }
    
    // MARK: - UI
    func setupCollectionView() {
        collectionView.register(OnboardingCell.self, forCellWithReuseIdentifier: OnboardingCell.reuseId)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isPagingEnabled = true
        collectionView.backgroundColor = UIColor(named: "DarkMode")
        collectionView.showsHorizontalScrollIndicator = false
    }
    
    func layoutViews() {
        view.addSubviews(collectionView, controlsContainerView)
        collectionView.anchor(top: view.topAnchor, right: view.rightAnchor, left: view.leftAnchor)
        collectionView.setDimension(height: view.heightAnchor, hMult: 0.666)
        
        controlsContainerView.anchor(top: collectionView.bottomAnchor, right: view.rightAnchor, bottom: view.bottomAnchor, left: view.leftAnchor)
        
        controlsContainerView.addSubview(controlStack)
        controlsContainerView.backgroundColor = UIColor(named: "DarkMode")
        nextButton.setDimension(wConst: 190, hConst: 50)
        controlStack.anchor(bottom: controlsContainerView.safeAreaLayoutGuide.bottomAnchor)
        controlStack.center(to: controlsContainerView, by: .centerX)
    }
    
    func updateNextbutton() {
        if pageControl.currentPage == onboardingObjs.count - 1 {
            skipButton.alpha = 0
            nextButton.setTitle(NSLocalizedString("GET STARTED", comment: "GET STARTED"), for: .normal)
        } else {
            skipButton.alpha = 1
            nextButton.setTitle(NSLocalizedString("NEXT", comment: "NEXT"), for: .normal)
        }
    }
    
    // MARK: - 3D touch Shortcuts
    func createQuickActions() {
        // if 3d touch is available
        if traitCollection.forceTouchCapability == .available {
            if let bundleIdentifier = Bundle.main.bundleIdentifier {
                let shortcutItem1 = UIApplicationShortcutItem(type: "\(bundleIdentifier).OpenFavorites", localizedTitle: NSLocalizedString("Show Favorites", comment: "Show Favorites"), localizedSubtitle: nil, icon: UIApplicationShortcutIcon(systemImageName: "star"), userInfo: nil)
                let shortcutItem2 = UIApplicationShortcutItem(type: "\(bundleIdentifier).OpenDiscover", localizedTitle: NSLocalizedString( "Discover Restaurants", comment:  "Discover Restaurants"), localizedSubtitle: nil, icon: UIApplicationShortcutIcon(systemImageName: "eyeglasses"), userInfo: nil)
                let shortcutItem3 = UIApplicationShortcutItem(type: "\(bundleIdentifier).NewRestaurant", localizedTitle: NSLocalizedString("New Restaurant", comment: "New Restaurant"), localizedSubtitle: nil, icon: UIApplicationShortcutIcon(type: .add), userInfo: nil)
                UIApplication.shared.shortcutItems = [shortcutItem1, shortcutItem2, shortcutItem3]
            }
        }
    }
    
    // MARK: - Selector
    @objc func handleNextButtonTapped() {
        if pageControl.currentPage == onboardingObjs.count - 1 {
            OnboardingManager.shared.setAsOldUser()
            createQuickActions()
            dismiss(animated: true, completion: nil)
        }
        
        collectionView.isPagingEnabled = false
        let nextIndex = min(pageControl.currentPage + 1, onboardingObjs.count - 1)
        pageControl.currentPage = nextIndex
        collectionView.scrollToItem(at: IndexPath(item: nextIndex, section: 0), at: .centeredHorizontally, animated: true)
        collectionView.isPagingEnabled = true
        updateNextbutton()
    }
    
    @objc func handleSkipButtonTapped() {
        OnboardingManager.shared.setAsOldUser()
        createQuickActions()
        dismiss(animated: true, completion: nil)
    }
    
    @objc func handlePageControlTapped() {
        collectionView.isPagingEnabled = false
        collectionView.scrollToItem(at: IndexPath(item: pageControl.currentPage, section: 0), at: .centeredHorizontally, animated: true)
        collectionView.isPagingEnabled = true
        updateNextbutton()
    }
}

// MARK: - UICollectionView FlowLayout + ScrollView
extension WalkThruVC: UICollectionViewDelegateFlowLayout {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return onboardingObjs.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: OnboardingCell.reuseId, for: indexPath) as! OnboardingCell
        cell.onboarding = onboardingObjs[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: view.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    override func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        pageControl.currentPage = Int(targetContentOffset.pointee.x) / Int(view.frame.width)
        updateNextbutton()
    }
}

// MARK: - UIAdaptivePresentationControllerDelegate
extension WalkThruVC: UIAdaptivePresentationControllerDelegate {
    func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        OnboardingManager.shared.setAsOldUser()
        createQuickActions()
    }
}
