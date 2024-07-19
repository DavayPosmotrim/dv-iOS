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
        finishDelegate?.didFinish(self)
    }

    func showRouletteStartViewController(with delegate: RouletteStartViewControllerDelegate?) {
        let viewController = RouletteStartViewController()
        viewController.modalTransitionStyle = .crossDissolve
        viewController.modalPresentationStyle = .overCurrentContext
        viewController.delegate = delegate
        navigationController.present(viewController, animated: true)
    }
}

private extension RouletteCoordinator {
    func showRoulette() {
        let viewController = RouletteSceneFactory.makeRouletteViewController(with: self)
        navigationController.pushViewController(viewController, animated: true)
    }
}
