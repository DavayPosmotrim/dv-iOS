//
//  SplahsCoordinator.swift
//  DavaiPosmotrim
//
//  Created by Maksim Zimens on 05.06.2024.
//

import Foundation

final class SplashScreenCoordinator: BaseCoordinator {

    override func start() {
        showSplashScreen()
    }

    override func finish() {
        finishDelegate?.didFinish(self)
    }
}

private extension SplashScreenCoordinator {
    func showSplashScreen() {
        let viewController = SplashScreenSceneFactory.makeSplashScreenViewController(with: self)
        navigationController.pushViewController(viewController, animated: true)
    }
}
