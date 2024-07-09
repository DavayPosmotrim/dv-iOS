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

    func showJoinSessionFlow() {
        let authSessionCoordinator = AuthCoordinator(
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
        case .createSession:
            navigationController.popToRootViewController(animated: true)
        case .movieSelectionOnboarding:
            break
        case .auth:
            break
        case .edit:
            break
        case .authSession:
            break
        case .main:
            break
        case .joinSession:
            navigationController.popToRootViewController(animated: true)
        case .coincidencesSession:
            break
        case .favoriteMovies:
            break
        case .sessionsList:
            break
        case .selectionMovies:
            break
        case .inviteUsers:
            navigationController.popToRootViewController(animated: true)
        default:
            navigationController.popToRootViewController(animated: false)
        }
    }
}
