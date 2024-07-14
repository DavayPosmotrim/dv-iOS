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
        let editCoordinator = AuthCoordinator(
            type: .edit,
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
        let authSessionCoordinator = AuthCoordinator(
            type: .authSession,
            finishDelegate: self,
            navigationController: navigationController
        )
        addChild(authSessionCoordinator)
        authSessionCoordinator.start()
    }

    func showJoinSessionFlow() {
        let joinSessionCoordinator = JoinSessionCoordinator(
            type: .joinSession,
            finishDelegate: self,
            navigationController: navigationController
        )
        addChild(joinSessionCoordinator)
        joinSessionCoordinator.start()
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
        case .authSession:
            showJoinSessionFlow()
        case .selectionMovies:
            showSessionsList()
        default:
            showMain()
        }
    }
}
