//
//  CoincidencesCoordinator.swift
//  DavaiPosmotrim
//
//  Created by Эльдар Айдумов on 12.06.2024.
//

import Foundation

final class CoincidencesCoordinator: BaseCoordinator {

    override func start() {
        showCoincidences()
    }

    override func finish() {
        navigationController.popViewController(animated: true)
    }
}

private extension CoincidencesCoordinator {
    func showCoincidences() {
        let viewController = CoincidencesSceneFactory.makeCoincidencesViewController(with: self)
        navigationController.pushViewController(viewController, animated: true)
    }
}
