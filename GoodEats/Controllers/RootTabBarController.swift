//
//  RootTabBarController.swift
//  GoodEats
//
//  Created by William Yeung on 2/16/21.
//

import UIKit

class RootTabBarController: UIViewController {
    // MARK: - Views
    private let tabBar: UITabBarController = {
        let tb = UITabBarController()
        
        let favoritesVC = UINavigationController(rootViewController: FavoritesVC())
        favoritesVC.tabBarItem = UITabBarItem(title: "Favorites", image: UIImage(named: "favorite"), tag: 0)
        
        let recentVC = UINavigationController(rootViewController: DiscoverVC())
        recentVC.tabBarItem = UITabBarItem(title: "Discover", image: UIImage(named: "discover"), tag: 1)
        
        let moreVC = UINavigationController(rootViewController: AboutVC())
        moreVC.tabBarItem = UITabBarItem(title: "About", image: UIImage(named: "about"), tag: 2)
        
        tb.viewControllers = [favoritesVC, recentVC, moreVC]
        
        return tb
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        layoutViews()
    }
    
    // MARK: - UI
    func configureUI() {
        
    }
    
    func layoutViews() {
        view.addSubview(tabBar.view)
    }
}
