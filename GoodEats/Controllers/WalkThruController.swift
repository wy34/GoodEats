//
//  WalkThruController.swift
//  GoodEats
//
//  Created by William Yeung on 2/15/21.
//

import UIKit

class WalkThruController: UIPageViewController {
    // MARK: - Properties
    var initialPage = 0
    var pages = [UIViewController]()
    
    // MARK: - Views
    lazy var pageControl: UIPageControl = {
        let pc = UIPageControl()
        pc.currentPageIndicatorTintColor = .black
        pc.pageIndicatorTintColor = .systemGray2
        pc.numberOfPages = pages.count
        pc.currentPage = initialPage
        pc.addTarget(self, action: #selector(pageControlTapped(_ :)), for: .valueChanged)
        return pc
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupPageVC()
//        layout()
    }
    
    // MARK: - Helpers
    func setupPageVC() {
        delegate = self
        dataSource = self
        
        for _ in 0..<3 {
            let page = OnboardingVC()
            page.view.backgroundColor = .white
            pages.append(page)
        }
        
        setViewControllers([pages[initialPage]], direction: .forward, animated: true, completion: nil)
    }

    func layout() {
        view.addSubview(pageControl)
        pageControl.setDimension(width: view.widthAnchor, wMult: 1)
        pageControl.setDimension(hConst: 20)
        pageControl.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor)
    }
    
    // MARK: - Selectors
    @objc func pageControlTapped(_ sender: UIPageControl) {
        setViewControllers([pages[sender.currentPage]], direction: .forward, animated: true, completion: nil)
    }
}

// MARK: - UIPageViewControllerDelegate/Datasource
extension WalkThruController: UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let currentIndex = pages.firstIndex(of: viewController) else { return nil }
        
        // swiping left
        if currentIndex == 0 { // if we are currently at the first vc
            return pages.last
        } else {
            return pages[currentIndex - 1]
        }
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let currentIndex = pages.firstIndex(of: viewController) else { return nil }
        
        if currentIndex == pages.count - 1 { // if we are currently at the last vc
            return pages.first
        } else {
            return pages[currentIndex + 1]
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        guard let viewControllers = pageViewController.viewControllers else { return }
        guard let currentIndex = pages.firstIndex(of: viewControllers[0]) else { return }
        
        pageControl.currentPage = currentIndex
    }
}
