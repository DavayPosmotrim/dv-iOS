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

    // MARK: - Initializers

    init(coordinator: AuthCoordinator) {
        self.coordinator = coordinator
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

    func startJoinSessionFlowNotification() {
        NotificationCenter.default.post(
            name: NSNotification.Name(Resources.MainScreen.startJoinSessionFlow),
            object: nil
        )
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
