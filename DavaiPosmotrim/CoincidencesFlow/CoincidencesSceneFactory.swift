//
//  CoincidencesSceneFactory.swift
//  DavaiPosmotrim
//
//  Created by Эльдар Айдумов on 12.06.2024.
//

import Foundation

struct CoincidencesSceneFactory {
    static func makeCoincidencesViewController(
        with coordinator: CoincidencesCoordinator
    ) -> CoincidencesViewController {
        let presenter = CoincidencesPresenter(coordinator: coordinator)
        let viewController = CoincidencesViewController(presenter: presenter)
        presenter.view = viewController
        return viewController
    }
}
