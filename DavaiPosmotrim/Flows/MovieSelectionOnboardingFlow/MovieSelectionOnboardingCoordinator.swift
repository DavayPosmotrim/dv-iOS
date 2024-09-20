//
//  MovieSelectionOnboardingCoordinator.swift
//  DavaiPosmotrim
//
//  Created by Эльдар Айдумов on 05.06.2024.
//

import Foundation

final class MovieSelectionOnboardingCoordinator: BaseCoordinator {

    override func start() {
        showMovieSelectionOnboarding()
    }

    override func finish() {
        finishDelegate?.didFinish(self)
    }
}

private extension MovieSelectionOnboardingCoordinator {
    func showMovieSelectionOnboarding() {
        let viewController = MovieSelectionOnboardingSceneFactory.makeMovieSelectionOnboardingViewController(with: self)
        navigationController.pushViewController(viewController, animated: true)
    }
}
