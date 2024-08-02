//
//  AuthPresenter.swift
//  DavaiPosmotrim
//
//  Created by Эльдар Айдумов on 04.05.2024.
//

import Foundation

final class AuthPresenter: AuthPresenterProtocol {

    // MARK: - Public Properties

    weak var coordinator: AuthCoordinator?
    weak var view: AuthViewProtocol?

    // MARK: - Private Properties

    private let userService: UserServiceProtocol = UserService()

    // MARK: - Initializers

    init(coordinator: AuthCoordinator) {
        self.coordinator = coordinator
    }

    // MARK: - Public methods

    func authFinish() {
        guard let coordinator else { return }
        coordinator.finish()
    }

    func checkUserNameProperty() -> String {
        guard let savedName = UserDefaults.standard.string(
            forKey: Resources.Authentication.savedNameUserDefaultsKey
        ) else {
            return ""
        }
        return savedName
    }
}

// MARK: - UserService

extension AuthPresenter {

    func createUser(name: String) {
        let deviceId = UUID().uuidString
        userService.createUser(deviceId: deviceId, name: name) { result in
            switch result {
            case .success(let user):
                UserDefaults.standard.setValue(user.name, forKey: Resources.Authentication.savedNameUserDefaultsKey)
                UserDefaults.standard.setValue(user.deviceId, forKey: Resources.Authentication.savedDeviceID)
                print(user)
            case .failure(let error):
                print("Failed to create user: \(error)")
            }
        }
    }
}
