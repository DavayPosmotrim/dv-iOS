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

        // Регистрация GenresService
        container.register(GenresServiceProtocol.self) { _ in
            GenresService()
        }

        // Регистрация CreateSessionPresenter с инъекцией GenresService и координатора
        container.register(CreateSessionPresenter.self) { (resolver, coordinator: CreateSessionCoordinator) in
            let genresService = resolver.resolve(GenresServiceProtocol.self)!
            return CreateSessionPresenter(coordinator: coordinator, genresService: genresService)
        }
    }

    func resolve<Service>(_ serviceType: Service.Type) -> Service? {
        return container.resolve(serviceType)
    }
}

