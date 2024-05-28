//
//  InvitingUsersFactory.swift
//  DavaiPosmotrim
//
//  Created by Aleksandr Garipov on 28.05.2024.
//

import Foundation

import Foundation

struct InvitingUsersFactory {
    static func invitingUsersViewController(with coordinator: InvitingUsersCoordinator) -> InvitingUsersViewController {
        let presenter = InvitingUsersPresenter(coordinator: coordinator)
        let viewController = InvitingUsersViewController(presenter: presenter)
        presenter.view = viewController
        return viewController
    }
}
