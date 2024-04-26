//
//  OnboardingSceneFactory.swift
//  DavaiPosmotrim
//
//  Created by Aleksandr Garipov on 23.04.2024.
//

import Foundation

struct OnboardingSceneFactory {
    static func makeOnboardingViewController(with coordinator: OnboardingCoordinator) -> OnboardingViewController {
        let presenter = OnboardingPresenter(coordinator: coordinator)
        let viewController = OnboardingViewController(presenter: presenter)
        presenter.view = viewController
        return viewController
    }
}
