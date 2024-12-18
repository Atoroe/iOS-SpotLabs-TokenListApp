//
//  AppDelegate.swift
//  Token List App
//
//  Created by Artem Poluyanovich on 18/12/2024.
//

import UIKit
import SDWebImage

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var coordinator: AppCoordinator?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        SDImageCache.shared.config.maxDiskSize = 100 * 1024 * 1024
        
        window = UIWindow(frame: UIScreen.main.bounds)
        let navigationController = UINavigationController()
        coordinator = AppCoordinator(window: window!, navigationController: navigationController)
        coordinator?.start()
        
        return true
    }
}

