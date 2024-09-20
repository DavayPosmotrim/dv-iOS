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

        switch coordinator.type {
        case .auth:
            viewController = AuthViewController(presenter: presenter, authEvent: .auth)
        case .edit:
            viewController = AuthViewController(presenter: presenter, authEvent: .edit)
        default:
            viewController = AuthViewController(presenter: presenter, authEvent: .joinSession)
        }

        presenter.view = viewController
        return viewController
    }
}
