//
//  CreateSessionFactory.swift
//  DavaiPosmotrim
//
//  Created by Iurii on 09.06.24.
//

import Foundation

struct CreateSessionFactory {
    static func createSessionViewController(with coordinator: CreateSessionCoordinator) -> CreateSessionViewController {
        let presenter = CreateSessionPresenter(coordinator: coordinator)
        let viewController = CreateSessionViewController(presenter: presenter)
        return viewController
    }
}
