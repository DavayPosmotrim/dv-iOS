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
    
    // MARK: - Initializers

    init(coordinator: EditNameCoordinator) {
        self.coordinator = coordinator
    }

    // MARK: - Public methods

    func finishEdit() {
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
