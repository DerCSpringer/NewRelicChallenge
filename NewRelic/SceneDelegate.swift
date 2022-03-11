//
//  SceneDelegate.swift
//  NewRelic
//
//  Created by newrelic on 8/15/20.
//  Copyright © 2020 newrelic. All rights reserved.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        let viewModel = AllCatsViewModel(catFetcher: CatFetcher.shared)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let allCatsVC = storyboard.instantiateViewController(identifier: "AllCatsViewController") { coder in
            AllCatsViewController(coder: coder, viewModel: viewModel)
        }
        let navigationController = UINavigationController(rootViewController: allCatsVC)
        window?.rootViewController = navigationController
    }

}

