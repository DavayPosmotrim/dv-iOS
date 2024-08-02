//
//  EditNamePresenter.swift
//  DavaiPosmotrim
//
//  Created by Эльдар Айдумов on 28.07.2024.
//

import Foundation

final class EditNamePresenter: EditNamePresenterProtocol {

    // MARK: - Public properties

    weak var coordinator: EditNameCoordinator?
    weak var view: EditNameViewProtocol?

    // MARK: - Private properties

    private let userService: UserServiceProtocol = UserService()

    // MARK: - Initializers

    init(coordinator: EditNameCoordinator) {
        self.coordinator = coordinator
    }

    // MARK: - Public methods

    func finishEdit() {
        guard let coordinator else { return }
        coordinator.finish()
    }

    func authDidFinishNotification(userName: String) {
        NotificationCenter.default.post(
            name: Notification.Name(Resources.Authentication.authDidFinishNotification),
            object: nil,
            userInfo: [Resources.Authentication.savedNameUserDefaultsKey: userName]
        )
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

extension EditNamePresenter {

    func updateUser(name: String) {
        guard let deviceId = UserDefaults.standard.string(forKey: Resources.Authentication.savedDeviceID) else { return }
        userService.updateUser(deviceId: deviceId, name: name) { result in
            switch result {
            case .success(let user):
                UserDefaults.standard.setValue(user.name, forKey: Resources.Authentication.savedNameUserDefaultsKey)
                print("User name updated: \(user.name), \(user.deviceId)")
            case .failure(let error):
                print("Failed to update user: \(error)")
            }
        }
    }
}
