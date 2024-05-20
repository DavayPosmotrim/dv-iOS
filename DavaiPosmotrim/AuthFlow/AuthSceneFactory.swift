//
//  AuthSceneFactory.swift
//  DavaiPosmotrim
//
//  Created by Эльдар Айдумов on 04.05.2024.
//

import Foundation

struct AuthSceneFactory {
    static func makeAuthViewController(with coordinator: AuthCoordinator) -> AuthViewController {
        let presenter = AuthPresenter(coordinator: coordinator)
        var viewController: AuthViewController
        if coordinator.type == .auth {
            viewController = AuthViewController(presenter: presenter, authEvent: .auth)
        } else {
            viewController = AuthViewController(presenter: presenter, authEvent: .edit)
        }
        presenter.view = viewController
        return viewController
    }
}
