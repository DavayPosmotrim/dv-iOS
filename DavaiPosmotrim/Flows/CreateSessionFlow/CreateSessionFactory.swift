//
//  CreateSessionFactory.swift
//  DavaiPosmotrim
//
//  Created by Iurii on 09.06.24.
//

import Foundation

struct CreateSessionFactory {
    static func createSessionViewController(with coordinator: CreateSessionCoordinator) -> CreateSessionViewController {
        let container = DependencyInjection.shared.container
        let presenter = container.resolve(CreateSessionPresenter.self, argument: coordinator)!
        let viewController = CreateSessionViewController(presenter: presenter)
        return viewController
    }
}
