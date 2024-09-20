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

    func showJoinSessionFlow() {
        let joinSessionCoordinator = JoinSessionCoordinator(
            type: .joinSession,
            finishDelegate: finishDelegate,
            navigationController: navigationController
        )
        addChild(joinSessionCoordinator)
        joinSessionCoordinator.start()
    }
}

private extension JoinSessionAuthCoordinator {

    func showJoinSessionAuthFlow() {
        let viewController = JoinSessionAuthSceneFactory.makeJoinSessionAuthViewController(with: self)
        navigationController.present(viewController, animated: true)
    }
}
