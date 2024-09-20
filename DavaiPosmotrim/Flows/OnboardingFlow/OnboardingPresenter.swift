//
//  OnboardingPresenter.swift
//  DavaiPosmotrim
//
//  Created by Эльдар Айдумов on 31.05.2024.
//

import Foundation

final class OnboardingPresenter: OnboardingPresenterProtocol {

    // MARK: - Public Properties

    weak var coordinator: OnboardingCoordinator?

    // MARK: - Initializers

    init(coordinator: OnboardingCoordinator) {
        self.coordinator = coordinator
    }

    // MARK: - Public methods

    func onboardingFinish() {
        guard let coordinator else { return }
        coordinator.finish()
    }
}
