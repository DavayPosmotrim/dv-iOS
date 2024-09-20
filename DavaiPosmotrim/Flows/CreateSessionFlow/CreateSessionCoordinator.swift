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

    func showInvitingUsersFlow() {
        showInvitingUsersScreen()
    }

    override func finish() {
        finishDelegate?.didFinish(self)
    }
}

private extension CreateSessionCoordinator {
    func showCreateSessionScreen() {
        let createSessionViewController = CreateSessionFactory.createSessionViewController(with: self)
        navigationController.pushViewController(createSessionViewController, animated: true)
    }

    func showInvitingUsersScreen() {
        let inviteUserCoordinator = InvitingUsersCoordinator(
            type: .inviteUsers,
            finishDelegate: finishDelegate,
            navigationController: navigationController
        )
        addChild(inviteUserCoordinator)
        inviteUserCoordinator.start()
    }
}
