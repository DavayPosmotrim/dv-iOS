//
//  JoinSessionCoordinator.swift
//  DavaiPosmotrim
//
//  Created by Эльдар Айдумов on 23.05.2024.
//

import Foundation

final class JoinSessionCoordinator: BaseCoordinator {

    override func start() {
        showJoinSession()
    }

    override func finish() {
        finishDelegate?.didFinish(self)
    }

    func showStartSessionScreen() {
        if UserDefaults.standard.value(
            forKey: Resources.MovieSelectionOnboarding.movieSelectionOnboardingUserDefaultsKey
        ) == nil {
            showMovieSelectionOnboardingScreen()
        } else {
            showSelectionMovieScreen()
        }
    }
}

private extension JoinSessionCoordinator {
    func showJoinSession() {
        let viewController = JoinSessionSceneFactory.makeJoinSessionViewController(with: self)
        navigationController.pushViewController(viewController, animated: true)
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

extension JoinSessionCoordinator: CoordinatorFinishDelegate {
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
