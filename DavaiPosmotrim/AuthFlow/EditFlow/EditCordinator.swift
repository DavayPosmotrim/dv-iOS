//
//  EditCordinator.swift
//  DavaiPosmotrim
//
//  Created by Эльдар Айдумов on 17.05.2024.
//

import Foundation

final class EditCoordinator: AuthCoordinator {

    override func start() {
        showEditFlow()
    }

    override func finish() {
        finishDelegate?.didFinish(self)
    }
}

private extension EditCoordinator {

    func showEditFlow() {
        let viewController = EditSceneFactory.makeAuthViewController(with: self)
        navigationController.present(viewController, animated: true)
    }
}
