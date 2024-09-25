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

    private let userService: UserServiceProtocol

    // MARK: - Initializers

    init(
        coordinator: EditNameCoordinator,
        userService: UserServiceProtocol = UserService()
    ) {
        self.coordinator = coordinator
        self.userService = userService
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

    func updateUser(name: String, completion: @escaping (Bool) -> Void) {
        guard let deviceId = UserDefaults.standard.string(
            forKey: Resources.Authentication.savedDeviceID
        ) else { return }
        view?.showLoader()
        userService.updateUser(deviceId: deviceId, name: name) { [weak self] result in
            guard let self else { return }
            self.view?.hideLoader()
            switch result {
            case .success(let user):
                UserDefaults.standard.setValue(user.name, forKey: Resources.Authentication.savedNameUserDefaultsKey)
                completion(true)
                print("User name updated: \(user.name), \(user.deviceId)")
            case .failure(let error):
                completion(false)
                view?.showError()
                print("Failed to update user: \(error)")
            }
        }
    }
}
