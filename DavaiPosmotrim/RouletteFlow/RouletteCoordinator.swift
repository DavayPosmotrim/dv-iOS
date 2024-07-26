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

    func showMatchViewController(matchModel: SelectionMovieCellModel, and completion: (() -> Void)?) {
        let viewController = MatchSelectionMoviesViewController(
            matchSelection: matchModel,
            buttonTitle: Resources.RouletteFlow.progressButtonText
        )
        viewController.modalPresentationStyle = .overFullScreen
        viewController.modalTransitionStyle = .crossDissolve
        navigationController.present(viewController, animated: true)
        viewController.dismissCompletion = { [weak self] in
            guard self != nil else { return }
            completion?()
        }
    }

    func showSessionsList() {
        let sessionsListCoordinator = SessionsListCoordinator(
            type: .sessionsList,
            finishDelegate: self,
            navigationController: navigationController
        )
        addChild(sessionsListCoordinator)
        sessionsListCoordinator.start()
    }
}

private extension RouletteCoordinator {
    func showRoulette() {
        let viewController = RouletteSceneFactory.makeRouletteViewController(with: self)
        navigationController.pushViewController(viewController, animated: true)
    }
}

// MARK: - CoordinatorFinishDelegate

extension RouletteCoordinator: CoordinatorFinishDelegate {
    func didFinish(_ coordinator: any CoordinatorProtocol) {
        switch coordinator.type {
        case .sessionsList:
            navigationController.popToRootViewController(animated: true)
            removeChild(coordinator)
        default:
            return
        }
    }
}
