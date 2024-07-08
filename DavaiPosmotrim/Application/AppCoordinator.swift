//
//  AppCoordinator.swift
//  DavaiPosmotrim
//
//  Created by Aleksandr Garipov on 23.04.2024.
//

import UIKit

final class AppCoordinator: BaseCoordinator {
    override func startSplash() {
        showSplashScreen()
    }

    override func start() {
        if UserDefaults.standard.value(forKey: Resources.Onboarding.onboardingUserDefaultsKey) == nil {
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

    func showSplashScreen() {
        let splashScreenCoordinator = SplashScreenCoordinator(
            type: .splash,
            finishDelegate: self,
            navigationController: navigationController)
        addChild(splashScreenCoordinator)
        splashScreenCoordinator.start()
    }

    func showCoincidencesFlow() {
        let coincidencesCoordinator = CoincidencesCoordinator(
            type: .coincidencesSession,
            navigationController: navigationController
        )
        addChild(coincidencesCoordinator)
        coincidencesCoordinator.start()
    }

    func showOnboardingFlow() {
        let onboardingCoordinator = OnboardingCoordinator(
            type: .onboarding,
            finishDelegate: self,
            navigationController: navigationController
        )
        addChild(onboardingCoordinator)
        onboardingCoordinator.start()
    }

    func showMovieSelectionOnboardingFlow() {
        let onboardingCoordinator = MovieSelectionOnboardingCoordinator(
            type: .movieSelectionOnboarding,
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

    func showMainFlow() {
        let mainCoordinator = MainCoordinator(
            type: .main,
            finishDelegate: self,
            navigationController: navigationController
        )
        addChild(mainCoordinator)
        mainCoordinator.start()
    }

    func showSelectionMoviesFlow() {
        // TODO: - не забыть перенести когда появится экран с которого необходимо запускать
        let selectionMoviesCoordinator = SelectionMoviesCoordinator(
            type: .selectionMovies,
            finishDelegate: self,
            navigationController: navigationController
        )
        addChild(selectionMoviesCoordinator)
        selectionMoviesCoordinator.start()
    }

    func showJoinSessionFlow() {
        let joinSessionCoordinator = JoinSessionCoordinator(
            type: .joinSession,
            finishDelegate: self,
            navigationController: navigationController
        )
        addChild(joinSessionCoordinator)
        joinSessionCoordinator.start()
    }
}

extension AppCoordinator: CoordinatorFinishDelegate {
    func didFinish(_ coordinator: CoordinatorProtocol) {
        removeChild(coordinator)
        switch coordinator.type {
        case .splash:
            start()
        case .app:
            return
        case .onboarding:
            showAuthFlow()
        case .movieSelectionOnboarding:
            // TODO: add code to start next flow
            print("MovieSelectionOnboarding")
        case .auth:
            showMainFlow()
        case .main:
            showJoinSessionFlow()
        case .joinSession:
            showMainFlow()
        case .selectionMovies:
            showMainFlow()
        default:
            navigationController.popToRootViewController(animated: false)
        }
    }
}
