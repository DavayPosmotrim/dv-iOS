//
//  AppCoordinator.swift
//  DavaiPosmotrim
//
//  Created by Aleksandr Garipov on 23.04.2024.
//

import UIKit

final class AppCoordinator: BaseCoordinator {
    override func start() {
        if UserDefaults.standard.value(forKey: "isOnboardingShown") == nil {
            showOnboardingFlow()
        } else if UserDefaults.standard.value(forKey: Resources.Authentication.savedNameUserDefaultsKey) == nil {
            showAuthFlow()
        } else {
            showMainFlow()
        }
    }

    override func finish() {
        print("AppCoordinator Finish")
    }
}

private extension AppCoordinator {

    func showOnboardingFlow() {
        let onboardingCoordinator = OnboardingCoordinator(
            type: .onboarding,
            finishDelegate: self,
            navigationController: navigationController
        )
        addChild(onboardingCoordinator)
        onboardingCoordinator.start()
    }

    func showAuthFlow() {
        let authCoordinator = AuthCoordinator(
            type: .auth,
            finishDelegate: self,
            navigationController: navigationController)
        addChild(authCoordinator)
        authCoordinator.start()
    }

    func showEditFlow() {
        let editCoordinator = AuthCoordinator(
            type: .edit,
            finishDelegate: self,
            navigationController: navigationController
        )
        addChild(editCoordinator)
        editCoordinator.start()
    }

    func showMainFlow() {
        let mainCoordinator = MainCoordinator(
            type: .main,
            finishDelegate: self,
            navigationController: navigationController
        )
        addChild(mainCoordinator)
        mainCoordinator.start()
    }
}

extension AppCoordinator: CoordinatorFinishDelegate {
    func didFinish(_ coordinator: CoordinatorProtocol) {
        removeChild(coordinator)
        switch coordinator.type {
        case .app:
            return
        case .onboarding:
            showAuthFlow()
        case .auth:
            showMainFlow()
        case .edit:
            showMainFlow()
        case .main:
            print("MainCoordinator finished")
        default:
            navigationController.popToRootViewController(animated: false)
        }
    }
}
