//
//  JoinSessionCoordinator.swift
//  DavaiPosmotrim
//
//  Created by Эльдар Айдумов on 23.05.2024.
//

import Foundation

final class JoinSessionCoordinator: BaseCoordinator {

    override func start() {
        showJoinSession()
    }

    override func finish() {
        finishDelegate?.didFinish(self)
    }
}

private extension JoinSessionCoordinator {
    func showJoinSession() {
        let viewController = JoinSessionSceneFactory.makeJoinSessionViewController(with: self)
        navigationController.setViewControllers([viewController], animated: true)
    }
}
