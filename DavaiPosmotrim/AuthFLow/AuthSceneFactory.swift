//
//  AuthSceneFactory.swift
//  DavaiPosmotrim
//
//  Created by Эльдар Айдумов on 04.05.2024.
//

import Foundation

struct AuthSceneFactory {
    static func makeAuthViewController(with coordinator: AuthCoordinator) -> AuthViewController {
        let savedUserName = UserDefaults.standard.string(forKey: "userName") ?? ""
        let presenter = AuthPresenter(coordinator: coordinator)
        let viewController = AuthViewController(presenter: presenter, userName: savedUserName)
        presenter.view = viewController
        return viewController
    }
}
