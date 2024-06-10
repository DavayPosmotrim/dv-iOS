//
//  MovieSelectionOnboardingPresenter.swift
//  DavaiPosmotrim
//
//  Created by Эльдар Айдумов on 05.06.2024.
//

import Foundation

final class MovieSelectionOnboardingPresenter: MovieSelectionOnboardingPresenterProtocol {

    // MARK: - Public Properties

    weak var coordinator: MovieSelectionOnboardingCoordinator?

    // MARK: - Initializers

    init(coordinator: MovieSelectionOnboardingCoordinator) {
        self.coordinator = coordinator
    }

    // MARK: - Public methods

    func nextButtonTapped() {
        guard let coordinator else { return }
        coordinator.finish()

        UserDefaults.standard.setValue(
            true,
            forKey: Resources.MovieSelectionOnboarding.movieSelectionOnboardingUserDefaultsKey
        )
    }
}
