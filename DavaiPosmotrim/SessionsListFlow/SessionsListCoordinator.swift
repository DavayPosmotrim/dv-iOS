//
//  SessionsListCoordinator.swift
//  DavaiPosmotrim
//
//  Created by Sergey Kemenov on 12.06.2024.
//

import Foundation

final class SessionsListCoordinator: BaseCoordinator {

    // MARK: - Public methods
    override func start() {
        showSessionsList()
    }

    override func finish() {
        navigationController.popViewController(animated: true)
    }
}

// MARK: - Private methods
private extension SessionsListCoordinator {

    func showSessionsList() {
        let presenter = SessionsListPresenter(coordinator: self)
        let viewController = SessionsListViewController(presenter: presenter)
        presenter.view = viewController
        navigationController.pushViewController(viewController, animated: true)
    }
}
