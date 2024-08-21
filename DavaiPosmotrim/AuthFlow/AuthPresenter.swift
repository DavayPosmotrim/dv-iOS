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

    func createUser(name: String, completion: @escaping (Bool) -> Void) {
        let deviceId = UUID().uuidString
        view?.showLoader()
        userService.createUser(deviceId: deviceId, name: name) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let user):
                UserDefaults.standard.setValue(user.name, forKey: Resources.Authentication.savedNameUserDefaultsKey)
                UserDefaults.standard.setValue(user.deviceId, forKey: Resources.Authentication.savedDeviceID)
                completion(true)
                print(user)
            case .failure(let error):
                completion(false)
                self.view?.showError()
                print("Failed to create user: \(error)")
            }
        }
        view?.hideLoader()
    }
}
