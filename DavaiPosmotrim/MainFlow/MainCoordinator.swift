//
//  MainCoordinator.swift
//  DavaiPosmotrim
//
//  Created by Iurii on 28.04.24.
//

import Foundation

final class MainCoordinator: BaseCoordinator {

    private struct Keys {
        static let authViewController = "AuthViewController"
        static let createSessionViewController = "CreateSessionViewController"
        static let favoriteMoviesViewController = "FavoriteMoviesViewController"
        static let joinSessionViewController = "JoinSessionViewController"
    }

    override func start() {
        showMain()
    }

    override func finish() {
        finishDelegate?.didFinish(self)
    }

    func showNextScreen(screen: String) {
        switch screen {
        case Keys.authViewController:
            showAuthFlow()
        case Keys.createSessionViewController:
            showCreateSessionFlow()
        case Keys.favoriteMoviesViewController:
            showFavoriteMoviesFlow()
        case Keys.joinSessionViewController:
            showJoinSessionFlow()
        default:
            break
        }
    }
}

private extension MainCoordinator {
    func showMain() {
        let viewController =  MainSceneFactory.makeMainViewController(with: self)
        navigationController.setViewControllers([viewController], animated: true)
    }

    func showAuthFlow() {
        let authViewController = AuthViewController()
        navigationController.setViewControllers([authViewController], animated: true)
    }

    func showCreateSessionFlow() {
        let createSessionViewController = CreateSessionViewController(presenter: CreateSessionPresenter())
        navigationController.pushViewController(createSessionViewController, animated: true)
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
