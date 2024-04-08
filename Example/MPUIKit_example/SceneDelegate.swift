//
//  SceneDelegate.swift
//  MPUIKit_example
//
//  Created by Marian Polek on 07/04/2024.
//

import UIKit
import MPUIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {

        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = UIViewController()
        AppDelegate.shared.window = window
        window.makeKeyAndVisible()
        
        AppDelegate.shared.startApp()
    }
}

