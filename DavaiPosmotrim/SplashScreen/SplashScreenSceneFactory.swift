//
//  SplashSceneFactory.swift
//  DavaiPosmotrim
//
//  Created by Maksim Zimens on 05.06.2024.
//

import Foundation

struct SplashScreenSceneFactory {
    static func makeSplashScreenViewController(
        with coordinator: SplashScreenCoordinator
    ) -> SplashScreenViewController {
        let presenter = SplashScreenPresenter(coordinator: coordinator)
        let viewController = SplashScreenViewController(presenter: presenter)
        presenter.view = viewController
        return viewController
    }
}
