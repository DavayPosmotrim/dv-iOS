//
//  File.swift
//  DavaiPosmotrim
//
//  Created by Эльдар Айдумов on 08.07.2024.
//

import Foundation

struct RouletteSceneFactory {
    static func makeRouletteViewController(
        with coordinator: RouletteCoordinator
    ) -> RouletteViewController {
        let presenter = RoulettePresenter(coordinator: coordinator)
        let viewController = RouletteViewController(presenter: presenter, event: .noWebSocket)
        presenter.view = viewController
        return viewController
    }

    static func makeWebSocketRouletteViewController(
        with coordinator: RouletteCoordinator
    ) -> RouletteViewController {
        let presenter = RoulettePresenter(coordinator: coordinator)
        let viewController = RouletteViewController(presenter: presenter, event: .webSocket)
        presenter.view = viewController
        return viewController
    }
}
