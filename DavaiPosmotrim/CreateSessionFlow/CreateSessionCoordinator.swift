//
//  CreateSessionCoordinator.swift
//  DavaiPosmotrim
//
//  Created by Iurii on 09.06.24.
//

import Foundation

final class CreateSessionCoordinator: BaseCoordinator {
    
    override func start() {
        showCreateSessionScreen()
    }

    override func finish() {
        navigationController.popViewController(animated: true)
    }
}

private extension CreateSessionCoordinator {
    func showCreateSessionScreen() {
        let createSessionViewController = CreateSessionFactory.createSessionViewController(with: self)
        navigationController.pushViewController(createSessionViewController, animated: true)
    }
}
