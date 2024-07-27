//
//  JoinSessionAuthCoordinator.swift
//  DavaiPosmotrim
//
//  Created by Эльдар Айдумов on 28.07.2024.
//

import Foundation

final class JoinSessionAuthCoordinator: BaseCoordinator {
    
    override func start() {
        showJoinSessionAuthFlow()
    }

    override func finish() {
        finishDelegate?.didFinish(self)
    }
}

private extension JoinSessionAuthCoordinator {

    func showJoinSessionAuthFlow() {
        let viewController = JoinSessionAuthSceneFactory.makeJoinSessionAuthViewController(with: self)
        navigationController.present(viewController, animated: true)
    }
}

    // MARK: - CoordinatorFinishDelegate

extension JoinSessionAuthCoordinator: CoordinatorFinishDelegate {

    func didFinish(_ coordinator: any CoordinatorProtocol) {
        switch coordinator.type {
        case .authSession:
            removeChild(coordinator)
        default:
            return
        }
    }
}
