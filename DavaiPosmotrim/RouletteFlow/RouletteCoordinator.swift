//
//  RouletteCoordinator.swift
//  DavaiPosmotrim
//
//  Created by Эльдар Айдумов on 08.07.2024.
//

import Foundation

final class RouletteCoordinator: BaseCoordinator {

    override func start() {
        showRoulette()
    }

    override func finish() {
        navigationController.popViewController(animated: true)
    }

}

private extension RouletteCoordinator {
    func showRoulette() {
        let viewController = RouletteSceneFactory.makeRouletteViewController(with: self)
        navigationController.pushViewController(viewController, animated: true)
    }
}
