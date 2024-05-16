//
//  EditSceneFactory.swift
//  DavaiPosmotrim
//
//  Created by Эльдар Айдумов on 17.05.2024.
//

import Foundation

struct EditSceneFactory {
    static func makeAuthViewController(with coordinator: EditCoordinator) -> AuthViewController {
        let presenter = AuthPresenter(editCoordinator: coordinator)
        let viewController = AuthViewController(presenter: presenter, event: .edit)
        presenter.view = viewController
        return viewController
    }
}
