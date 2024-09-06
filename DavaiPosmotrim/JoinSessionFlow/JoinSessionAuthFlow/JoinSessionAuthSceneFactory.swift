//
//  JoinSesisonAuthSceneFactory.swift
//  DavaiPosmotrim
//
//  Created by Эльдар Айдумов on 28.07.2024.
//

import Foundation

struct JoinSessionAuthSceneFactory {
    static func makeJoinSessionAuthViewController(with coordinator: JoinSessionAuthCoordinator) -> JoinSessionAuthViewController {
        let presenter = JoinSessionAuthPresenter(coordinator: coordinator)
        let viewController = JoinSessionAuthViewController(presenter: presenter)
        presenter.view = viewController
        return viewController
    }
}
