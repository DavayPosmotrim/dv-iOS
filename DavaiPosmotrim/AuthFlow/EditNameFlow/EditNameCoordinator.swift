//
//  EditNameCoordinator.swift
//  DavaiPosmotrim
//
//  Created by Эльдар Айдумов on 28.07.2024.
//

import Foundation

final class EditNameCoordinator: BaseCoordinator {

    override func start() {
        showEditNameFlow()
    }

    override func finish() {
        finishDelegate?.didFinish(self)
        print("finish edit")
    }
}

private extension EditNameCoordinator {

    func showEditNameFlow() {
        let viewController = EditNameSceneFactory.makeEditNameViewController(with: self)
        navigationController.present(viewController, animated: true)
    }
}
