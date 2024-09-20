//
//  EditNameSceneFactory.swift
//  DavaiPosmotrim
//
//  Created by Эльдар Айдумов on 28.07.2024.
//

import Foundation

struct EditNameSceneFactory {
    static func makeEditNameViewController(
        with coordinator: EditNameCoordinator
    ) -> EditNameViewController {
        let presenter = EditNamePresenter(coordinator: coordinator)
        let viewController = EditNameViewController(presenter: presenter)
        presenter.view = viewController
        return viewController
    }
}
