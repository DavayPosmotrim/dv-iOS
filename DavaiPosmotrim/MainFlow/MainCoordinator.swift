//
//  MainCoordinator.swift
//  DavaiPosmotrim
//
//  Created by Iurii on 28.04.24.
//

import Foundation

final class MainCoordinator: BaseCoordinator {

    override func start() {
        showMain()
    }

    override func finish() {
        finishDelegate?.didFinish(self)
    }

    func showNextScreen(screen: String) {
        switch screen {
        case "AuthViewController":
            showAuthFlow()
        case "CreateSessionViewController":
            showCreateSessionFlow()
        case "FavoriteMoviesViewController":
            showFavoriteMoviesFlow()
        case "JoinSessionViewController":
            showJoinSessionFlow()
        default:
            break
        }
    }
}

private extension MainCoordinator {
    func showMain() {
        let viewController =  MainSceneFactory.makeMainViewController(with: self)
        navigationController.pushViewController(viewController, animated: true)
    }

    func showAuthFlow() {
        let authViewController = AuthViewController()
        navigationController.setViewControllers([authViewController], animated: true)
    }

    func showCreateSessionFlow() {
        let createSessionViewController = CreateSessionViewController()
        navigationController.setViewControllers([createSessionViewController], animated: true)
    }

    func showFavoriteMoviesFlow() {
        let favoriteMoviesViewController = FavoriteMoviesViewController()
        navigationController.setViewControllers([favoriteMoviesViewController], animated: true)
    }

    func showJoinSessionFlow() {
        let joinSessionViewController = JoinSessionViewController()
        navigationController.setViewControllers([joinSessionViewController], animated: true)
    }
}
