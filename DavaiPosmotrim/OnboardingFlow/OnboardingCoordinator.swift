//
//  OnboardingCoordinator.swift
//  DavaiPosmotrim
//
//  Created by Aleksandr Garipov on 23.04.2024.
//

import Foundation

final class OnboardingCoordinator: BaseCoordinator {

    override func start() {
        showOnboarding()
    }

    override func finish() {
        finishDelegate?.didFinish(self)
    }
}

private extension OnboardingCoordinator {
    func showOnboarding() {
        let viewController = OnboardingSceneFactory.makeOnboardingViewController(with: self)
        navigationController.setViewControllers([viewController], animated: true)
    }
}
