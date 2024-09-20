//
//  InvitingUsersCoordinator.swift
//  DavaiPosmotrim
//
//  Created by Aleksandr Garipov on 28.05.2024.
//

import Foundation

final class InvitingUsersCoordinator: BaseCoordinator {

    override func start() {
        showInvitingUsersScreen()
    }

    override func finish() {
        finishDelegate?.didFinish(self)
    }

    func showStartSessionScreen() {
        if UserDefaults.standard.value(forKey: Resources.MovieSelectionOnboarding.movieSelectionOnboardingUserDefaultsKey) == nil {
            showMovieSelectionOnboardingScreen()
        } else {
            showSelectionMovieScreen()
        }
    }
}

private extension InvitingUsersCoordinator {

    func showInvitingUsersScreen() {
        let invitingUsersViewController = InvitingUsersFactory.invitingUsersViewController(with: self)
        navigationController.pushViewController(invitingUsersViewController, animated: true)
    }

    func showSelectionMovieScreen() {
        let selectionMovieCoordinator = SelectionMoviesCoordinator(
            type: .selectionMovies,
            finishDelegate: finishDelegate,
            navigationController: navigationController)
        addChild(selectionMovieCoordinator)
        selectionMovieCoordinator.start()
    }

    func showMovieSelectionOnboardingScreen() {
        let movieSelectionOnboardingCoordinator = MovieSelectionOnboardingCoordinator(
            type: .movieSelectionOnboarding,
            finishDelegate: self,
            navigationController: navigationController)
        addChild(movieSelectionOnboardingCoordinator)
        movieSelectionOnboardingCoordinator.start()
    }
}

// MARK: - CoordinatorFinishDelegate

extension InvitingUsersCoordinator: CoordinatorFinishDelegate {
    func didFinish(_ coordinator: any CoordinatorProtocol) {
        switch coordinator.type {
        case .movieSelectionOnboarding:
            showSelectionMovieScreen()
            removeChild(coordinator)
        default:
            return
        }
    }
}
