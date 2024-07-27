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

    private let charactersMinNumber = 2
    private let charactersBarrierNumber = 12
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

    func calculateCharactersNumber(with text: String) {
        if text.isEmpty {
            view?.updateUIElements(
                text: Resources.Authentication.lowerLabelInputNameWarningText,
                font: nil,
                labelProperty: false,
                buttonProperty: false
            )
        } else if text.count < charactersMinNumber {
            view?.updateUIElements(
                text: Resources.Authentication.lowerLabelLengthWarningText,
                font: nil,
                labelProperty: false,
                buttonProperty: false
            )
        } else if text.count > charactersBarrierNumber {
            view?.updateUIElements(
                text: nil,
                font: .textLabelFont,
                labelProperty: true,
                buttonProperty: true
            )
        } else {
            view?.updateUIElements(
                text: nil,
                font: .textHeadingFont,
                labelProperty: true,
                buttonProperty: true
            )
        }
    }

    func checkSessionCode(with code: String) {
        let createdCode = "AAaa567"
        UserDefaults.standard.setValue(createdCode, forKey: Resources.JoinSession.joinSessionCreatedCode)

        // TODO: - add logic to fetch createdCode from server

        if code == createdCode {
            view?.updateUIElements(
                text: nil,
                font: nil,
                labelProperty: true,
                buttonProperty: true
            )
        } else {
            view?.updateUIElements(
                text: Resources.Authentication.lowerLabelSessionNotFound,
                font: nil,
                labelProperty: false,
                buttonProperty: false
            )
        }
    }

    func handleEnterButtonTap(with name: String) -> String {
        if name.isEmpty {
            view?.updateUIElements(
                text: Resources.Authentication.lowerLabelInputNameWarningText,
                font: nil,
                labelProperty: false,
                buttonProperty: false
            )
            return ""
        } else {
            UserDefaults.standard.setValue(name, forKey: Resources.Authentication.savedNameUserDefaultsKey)
            return checkUserNameProperty()
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

    func authDidFinishNotification(userName: String) {
        NotificationCenter.default.post(
            name: Notification.Name(Resources.Authentication.authDidFinishNotification),
            object: nil,
            userInfo: [Resources.Authentication.savedNameUserDefaultsKey: userName]
        )
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
