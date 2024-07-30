//
//  DependencyInjection.swift
//  DavaiPosmotrim
//
//  Created by Aleksandr Garipov on 28.07.2024.
//

import Foundation
import Swinject

class DependencyInjection {
    static let shared = DependencyInjection()
    let container: Container

    private init() {
        container = Container()

        // Регистрация ContentService
        container.register(ContentServiceProtocol.self) { _ in
            ContentService()
        }

        // Регистрация CreateSessionPresenter с инъекцией ContentService и координатора
        container.register(CreateSessionPresenter.self) { (resolver, coordinator: CreateSessionCoordinator) in
            let contentService = resolver.resolve(ContentServiceProtocol.self)!
            return CreateSessionPresenter(coordinator: coordinator, contentService: contentService)
        }
    }

    func resolve<Service>(_ serviceType: Service.Type) -> Service? {
        return container.resolve(serviceType)
    }
}
