//
//  SelectionMoviesCoordinator.swift
//  DavaiPosmotrim
//
//  Created by Iurii on 15.06.24.
//

import Foundation

final class SelectionMoviesCoordinator: BaseCoordinator {

    override func start() {
        showSelectionMoviesScreen()
    }

    func showMatchFlow() {
            let coincidencesCoordinator = CoincidencesCoordinator(
                type: .coincidencesSession,
                finishDelegate: finishDelegate,
                navigationController: navigationController
            )
            addChild(coincidencesCoordinator)
            coincidencesCoordinator.start()
    }

    override func finish() {
        finishDelegate?.didFinish(self)
    }
}

private extension SelectionMoviesCoordinator {
    func showSelectionMoviesScreen() {
        let selectionMoviesViewController = SelectionMoviesFactory.makeSelectionMoviesViewController(with: self)
        navigationController.pushViewController(selectionMoviesViewController, animated: true)
    }
}
