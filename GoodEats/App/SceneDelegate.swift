//
//  SceneDelegate.swift
//  GoodEats
//
//  Created by William Yeung on 2/8/21.
//

import UIKit

enum QuickAction: String {
    case OpenFavorites = "OpenFavorites"
    case OpenDiscover = "OpenDiscover"
    case NewRestaurant = "NewRestaurant"
    
    init?(fullIdentifier: String) {
        guard let shortcutIdentifier = fullIdentifier.components(separatedBy: ".").last else { return nil }
        self.init(rawValue: shortcutIdentifier)
    }
}

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let scene = (scene as? UIWindowScene) else { return }
        window = UIWindow(frame: scene.coordinateSpace.bounds)
        window?.windowScene = scene
        window?.makeKeyAndVisible()
        window?.rootViewController = RootTabBarController()
    }
    
    
    // called when user selects an action from the shortcut menu
    func windowScene(_ windowScene: UIWindowScene, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
        completionHandler(handleQuickAction(shortcutItem: shortcutItem))
    }
    
    private func handleQuickAction(shortcutItem: UIApplicationShortcutItem) -> Bool {
        let shortcutType = shortcutItem.type
        guard let shortcutIdentifier = QuickAction(fullIdentifier: shortcutType) else { return false }
        guard let tabBarController = window?.rootViewController as? RootTabBarController else { return false }
        
        switch shortcutIdentifier {
            case .OpenFavorites:
                tabBarController.tabBar.selectedIndex = 0
            case .OpenDiscover:
                tabBarController.tabBar.selectedIndex = 1
            case .NewRestaurant:
                if let favoritesVC = tabBarController.tabBar.viewControllers?[0] {
                    let addNewRestaurantVC = UINavigationController(rootViewController: AddNewRestaurantVC())
                    favoritesVC.present(addNewRestaurantVC, animated: true, completion: nil)
                } else {
                    return false
                }
        }
        
        return true
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

