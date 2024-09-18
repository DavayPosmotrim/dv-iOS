//
//  JoinSessionSceneFactory.swift
//  DavaiPosmotrim
//
//  Created by Эльдар Айдумов on 23.05.2024.
//

import Foundation

struct JoinSessionSceneFactory {
    static func makeJoinSessionViewController(with coordinator: JoinSessionCoordinator) -> JoinSessionViewController {
        let presenter = JoinSessionPresenter(coordinator: coordinator)
        let viewController = JoinSessionViewController(presenter: presenter)
        presenter.view = viewController
        return viewController
    }
}
