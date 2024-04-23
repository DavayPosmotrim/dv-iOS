//
//  AppCoordinatorProtocol.swift
//  DavaiPosmotrim
//
//  Created by Aleksandr Garipov on 23.04.2024.
//

import Foundation

protocol AppCoordinatorProtocol: CoordinatorProtocol {
    func showOnboardingFlow()
    func showRegistrationFlow()
    func showMainFlow()
}
