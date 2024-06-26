//
//  InvitingUsersCoordinator.swift
//  DavaiPosmotrim
//
//  Created by Aleksandr Garipov on 28.05.2024.
//

import Foundation

final class InvitingUsersCoordinator: BaseCoordinator {
    override func start() {
        showInvitingUsersScreen()
    }

    override func finish() {
        finishDelegate?.didFinish(self)
    }
}

private extension InvitingUsersCoordinator {
    func showInvitingUsersScreen() {
        let invitingUsersViewController = InvitingUsersFactory.invitingUsersViewController(with: self)
        navigationController.pushViewController(invitingUsersViewController, animated: true)
    }
}
