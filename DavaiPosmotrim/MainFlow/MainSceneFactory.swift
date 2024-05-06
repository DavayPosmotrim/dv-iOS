//
//  MainSceneFactory.swift
//  DavaiPosmotrim
//
//  Created by Iurii on 28.04.24.
//

import Foundation

struct MainSceneFactory {
    static func makeMainViewController(with coordinator: MainCoordinator) -> MainViewController {
        let presenter = MainPresenter(coordinator: coordinator)
        let viewController = MainViewController(presenter: presenter)
        presenter.view = viewController
        return viewController
    }
}
