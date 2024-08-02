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

        // Do not forget to delete after a while
        getUser(deviceID: "550e8400-e29b-41d4-a716-446655440000")
        UserDefaults.standard.setValue("550e8400-e29b-41d4-a716-446655440000", forKey: Resources.Authentication.savedDeviceID)
    }

    // MARK: - Public methods

    func authFinish() {
        guard let coordinator else { return }
        coordinator.finish()
    }

    // Переделать на делегат или кложер

    func authDidFinishNotification(userName: String) {
        NotificationCenter.default.post(
            name: Notification.Name(Resources.Authentication.authDidFinishNotification),
            object: nil,
            userInfo: [Resources.Authentication.savedNameUserDefaultsKey: userName]
        )
    }

    func handleEnterButtonTap(with name: String) {
        if name.isEmpty {
            view?.updateUIElements(
                text: Resources.Authentication.lowerLabelInputNameWarningText,
                font: nil,
                labelIsHidden: false,
                buttonIsEnabled: false
            )
        } else {
            UserDefaults.standard.setValue(name, forKey: Resources.Authentication.savedNameUserDefaultsKey)
        }
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
    func getUser(deviceID: String) {
        userService.getUser(deviceId: deviceID) { result in
            switch result {
            case .success(let user):
                print("User retrieved: \(user)")
            case .failure(let error):
                print("Failed to get user: \(error)")
            }
        }
    }

    func createUser(name: String) {
        let deviceId = UUID().uuidString
        userService.createUser(deviceId: deviceId, name: name) { result in
            switch result {
            case .success(let user):
                UserDefaults.standard.setValue(user.name, forKey: Resources.Authentication.savedNameUserDefaultsKey)
                UserDefaults.standard.setValue(user.deviceId, forKey: Resources.Authentication.savedDeviceID)
            case .failure(let error):
                print("Failed to get user: \(error)")
            }
        }
    }

    func updateUser(name: String) {
        guard let deviceId = UserDefaults.standard.string(forKey: Resources.Authentication.savedDeviceID) else { return }
        userService.updateUser(deviceId: deviceId, name: name) { result in
            switch result {
            case .success(let user):
                UserDefaults.standard.setValue(user.name, forKey: Resources.Authentication.savedNameUserDefaultsKey)
            case .failure(let error):
                print("Failed to get user: \(error)")
            }
        }
    }
}
