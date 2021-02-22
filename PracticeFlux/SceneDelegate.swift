//
//  SceneDelegate.swift
//  PracticeFlux
//
//  Created by 河明宗 on 2021/01/07.
//  Copyright © 2021 河明宗. All rights reserved.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    
    private let actionCreator = ActionCreator()
    private let searchStore = SearchRepositoryStore.shared
    private let detailStore = RepositoryDetailStore.shared
    private let favoriteStore = FavoriteRepositoryStore.shared
    
    private lazy var showRepositoryDetailSubscription: Subscription = {
        return detailStore.addListner { [weak self] in
            DispatchQueue.main.async {
                guard
                    let self = self,
                    self.detailStore.repository != nil,
                    let rootVC = self.window?.rootViewController,
                    let tbc = rootVC as? UITabBarController,
                    let selectedVC = tbc.selectedViewController,
                    let nc = selectedVC as? UINavigationController
                    else { return }
                let vc = RepositoryDetailViewController(actionCreator: self.actionCreator)
                nc.pushViewController(vc, animated: true)
            }
        }
    }()

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        
        let tabBarController = UITabBarController()
        let tabs: [(UINavigationController, UITabBarItem.SystemItem)] = [
            (UINavigationController(rootViewController: RepositorySearchViewController(searchStore: searchStore, actionCreator: actionCreator)), .search),
            (UINavigationController(rootViewController: RepositorySearchViewController(searchStore: searchStore, actionCreator: actionCreator)), .favorites)
        ]
        tabs.enumerated().forEach {
            $0.element.0.tabBarItem = UITabBarItem(tabBarSystemItem: $0.element.1, tag: $0.offset)
        }
        tabBarController.setViewControllers(tabs.map { $0.0 }, animated: false)
        
        window?.rootViewController = tabBarController
        window?.makeKeyAndVisible()
        
        _ = showRepositoryDetailSubscription
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
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

        // Save changes in the application's managed object context when the application transitions to the background.
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }


}

