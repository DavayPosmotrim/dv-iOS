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
                finishDelegate: self,
                navigationController: navigationController
            )
            addChild(coincidencesCoordinator)
            coincidencesCoordinator.start()
    }

    override func finish() {
        finishDelegate?.didFinish(self)
    }
}

    // MARK: - Private methods

private extension SelectionMoviesCoordinator {
    func showSelectionMoviesScreen() {
        let selectionMoviesViewController = SelectionMoviesFactory.makeSelectionMoviesViewController(with: self)
        navigationController.pushViewController(selectionMoviesViewController, animated: true)
    }
}

    // MARK: - CoordinatorFinishDelegate

extension SelectionMoviesCoordinator: CoordinatorFinishDelegate {
    func didFinish(_ coordinator: any CoordinatorProtocol) {
        switch coordinator.type {
        case .coincidencesSession:
            navigationController.popViewController(animated: true)
            removeChild(coordinator)
        default:
            return
        }
    }
}
