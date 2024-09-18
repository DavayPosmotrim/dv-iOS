//
//  MovieSelectionOnboardingSceneFactory.swift
//  DavaiPosmotrim
//
//  Created by Эльдар Айдумов on 05.06.2024.
//

import Foundation

struct MovieSelectionOnboardingSceneFactory {
    static func makeMovieSelectionOnboardingViewController(
        with coordinator: MovieSelectionOnboardingCoordinator
    ) -> MovieSelectionOnboardingViewController {
        let presenter = MovieSelectionOnboardingPresenter(coordinator: coordinator)
        let viewController = MovieSelectionOnboardingViewController(presenter: presenter)
        return viewController
    }
}
