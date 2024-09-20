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
            finishDelegate: self,
            navigationController: navigationController)
        addChild(rouletteCoordinator)
        rouletteCoordinator.start()
    }

    func showRouletteOnboarding() {
        let viewController = RouletteOnboardingViewController()
        viewController.modalTransitionStyle = .crossDissolve
        viewController.modalPresentationStyle = .overCurrentContext
        navigationController.present(viewController, animated: true)
    }

    func showCoincidencesInfo(with viewModel: SelectionMovieCellModel) {
        let viewController = CoincidencesMovieInfoViewController(viewModel: viewModel)
        navigationController.pushViewController(viewController, animated: true)
    }
}

private extension CoincidencesCoordinator {
    func showCoincidences() {
        let viewController = CoincidencesSceneFactory.makeCoincidencesViewController(with: self)
        navigationController.pushViewController(viewController, animated: true)
    }
}

    // MARK: - CoordinatorFinishDelegate

extension CoincidencesCoordinator: CoordinatorFinishDelegate {
    func didFinish(_ coordinator: any CoordinatorProtocol) {
        switch coordinator.type {
        case .roulette:
            navigationController.popViewController(animated: true)
            removeChild(coordinator)
        default:
            return
        }
    }
}
