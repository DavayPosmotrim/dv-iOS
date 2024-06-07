//
//  MovieSelectionOnboardingPresenter.swift
//  DavaiPosmotrim
//
//  Created by Эльдар Айдумов on 05.06.2024.
//

import Foundation

final class MovieSelectionOnboardingPresenter: MovieSelectionOnboardingProtocol {

    // MARK: - Public Properties

    weak var coordinator: MovieSelectionOnboardingCoordinator?

    // MARK: - Initializers

    init(coordinator: MovieSelectionOnboardingCoordinator) {
        self.coordinator = coordinator
    }

    // MARK: - Public methods

    func movieSelectionOnboardingFinish() {
        guard let coordinator else { return }
        coordinator.finish()
    }
}
