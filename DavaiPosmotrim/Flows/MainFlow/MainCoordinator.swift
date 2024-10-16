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
                showSessionsList()
        case Keys.joinSessionViewController:
            showJoinSessionAuth()
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
        let editCoordinator = EditNameCoordinator(
            type: .edit,
            finishDelegate: self,
            navigationController: navigationController
        )
        addChild(editCoordinator)
        editCoordinator.start()
    }

    func showCreateSessionFlow() {
        let createSessionCoordinator = CreateSessionCoordinator(
            type: .createSession,
            finishDelegate: self,
            navigationController: navigationController
        )
        addChild(createSessionCoordinator)
        createSessionCoordinator.start()
    }

    func showJoinSessionAuth() {
        let authSessionCoordinator = JoinSessionAuthCoordinator(
            type: .authSession,
            finishDelegate: self,
            navigationController: navigationController
        )
        addChild(authSessionCoordinator)
        authSessionCoordinator.start()
    }

    func showSessionsList() {
        let sessionsListCoordinator = SessionsListCoordinator(
            type: .sessionsList,
            finishDelegate: self,
            navigationController: navigationController
        )
        addChild(sessionsListCoordinator)
        sessionsListCoordinator.start()
    }
}

// MARK: - CoordinatorFinishDelegate

extension MainCoordinator: CoordinatorFinishDelegate {
    func didFinish(_ coordinator: CoordinatorProtocol) {
        childCoordinators.removeAll()
        switch coordinator.type {
        case .selectionMovies:
            showSessionsList()
        default:
            navigationController.popToRootViewController(animated: true)
        }
    }
}
