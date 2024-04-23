//
//  OnboardingCoordinator.swift
//  DavaiPosmotrim
//
//  Created by Aleksandr Garipov on 23.04.2024.
//

import Foundation

final class OnboardingCoordinator: BaseCoordinator {
    override func start() {
        let viewController = OnboardingViewController()
        navigationController.pushViewController(viewController, animated: true)
    }
}
