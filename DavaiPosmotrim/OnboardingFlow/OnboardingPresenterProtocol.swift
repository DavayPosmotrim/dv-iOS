//
//  OnboardingPresenter.swift
//  DavaiPosmotrim
//
//  Created by Aleksandr Garipov on 23.04.2024.
//

import Foundation

protocol OnboardingPresenterProtocol: AnyObject {
    func onboardingFinish()
}

final class OnboardingPresenter: OnboardingPresenterProtocol {

    // MARK: - Public Properties
    weak var coordinator: OnboardingCoordinator?
    weak var view: OnboardingViewProtocol?

    init(coordinator: OnboardingCoordinator) {
        self.coordinator = coordinator
    }

    func onboardingFinish() {
        guard let coordinator else { return }
        coordinator.finish()
    }
}
