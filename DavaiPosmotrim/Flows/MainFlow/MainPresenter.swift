//
//  MainPresenterProtocol.swift
//  DavaiPosmotrim
//
//  Created by Iurii on 28.04.24.
//

import Foundation

final class MainPresenter: MainPresenterProtocol {

    // MARK: - Public Properties

    weak var coordinator: MainCoordinator?

    // MARK: - Private properties

    private let userService: UserServiceProtocol

    // MARK: - Initializers

    init(coordinator: MainCoordinator, userService: UserServiceProtocol = UserService()) {
        self.coordinator = coordinator
        self.userService = userService
    }

    // MARK: - Public methods

    func didTapButtons(screen: String) {
        guard let coordinator else { return }
        coordinator.showNextScreen(screen: screen)
    }

    func checkUserNameProperty() -> String {
        guard let savedName = UserDefaults.standard.string(
            forKey: Resources.Authentication.savedNameUserDefaultsKey
        ) else {
            return ""
        }
        return savedName
    }

    func getUserName(_ notification: Notification) -> String {
        guard let userInfo = notification.userInfo,
              let userName = userInfo[Resources.Authentication.savedNameUserDefaultsKey] as? String else {
            return ""
        }
        return userName
    }
}
