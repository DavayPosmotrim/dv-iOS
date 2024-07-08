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
        finishDelegate?.didFinish(self)
    }

    func showRouletteFlow() {
        let rouletteCoordinator = RouletteCoordinator(
            type: .roulette,
            navigationController: navigationController)
        addChild(rouletteCoordinator)
        rouletteCoordinator.start()
    }
}

private extension CoincidencesCoordinator {
    func showCoincidences() {
        let viewController = CoincidencesSceneFactory.makeCoincidencesViewController(with: self)
        navigationController.pushViewController(viewController, animated: true)
    }
}
