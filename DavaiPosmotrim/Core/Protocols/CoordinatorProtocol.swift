//
//  CoordinatorProtocol.swift
//  DavaiPosmotrim
//
//  Created by Aleksandr Garipov on 23.04.2024.
//

import UIKit

enum CoordinatorType {
    case splash
    case app
    case onboarding
    case movieSelectionOnboarding
    case auth
    case edit
    case authSession
    case main
    case createSession
    case joinSession
    case coincidencesSession
    case roulette
    case favoriteMovies
    case sessionsList
    case selectionMovies
    case inviteUsers
}

protocol CoordinatorFinishDelegate: AnyObject {
    func didFinish(_ coordinator: CoordinatorProtocol)
}

protocol CoordinatorProtocol: AnyObject {
    var type: CoordinatorType { get }
    var finishDelegate: CoordinatorFinishDelegate? { get set }
    var navigationController: UINavigationController { get set }
    var childCoordinators: [CoordinatorProtocol] { get set }

    func start()
    func startSplash()
    func finish()
}

extension CoordinatorProtocol {

    func addChild(_ coordinator: CoordinatorProtocol) {
        childCoordinators.append(coordinator)
    }

    func removeChild(_ coordinator: CoordinatorProtocol) {
        childCoordinators = childCoordinators.filter { $0 !== coordinator }
    }
}
