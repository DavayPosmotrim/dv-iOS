//
//  AuthCoordinator.swift
//  DavaiPosmotrim
//
//  Created by Эльдар Айдумов on 04.05.2024.
//

import Foundation

final class AuthCoordinator: BaseCoordinator {

    override func start() {
        showAuthentication()
    }

    override func finish() {
        finishDelegate?.didFinish(self)
    }
}

private extension AuthCoordinator {

    func showAuthentication() {
        let viewController = AuthSceneFactory.makeAuthViewController(with: self)
        navigationController.setViewControllers([viewController], animated: true)
    }
}
