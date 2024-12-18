//
//  AppCoordinator.swift
//  Token List App
//
//  Created by Artem Poluyanovich on 18/12/2024.
//

import UIKit

// MARK: - Coordinator
protocol Coordinator: AnyObject {
    var childCoordinators: [Coordinator] { get set }
    var navigationController: UINavigationController { get set }
    
    func start()
}

// MARK: AppCoordinator
final class AppCoordinator: Coordinator {
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    var window: UIWindow
    
    // MARK: - Init
    init(window: UIWindow, navigationController: UINavigationController) {
        self.window = window
        self.navigationController = navigationController
    }
    
    // MARK: - Start
    func start() {
        let networkService = RestService()
        let tokensService = TokensService(networkService: networkService)
        let viewModel = TokenListViewModel(tokensService: tokensService)
        let rootViewController = TokenListViewController(viewModel: viewModel)
        
        navigationController.viewControllers = [rootViewController]
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
}
