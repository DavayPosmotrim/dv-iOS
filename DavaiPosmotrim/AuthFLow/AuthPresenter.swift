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
                buttonProperty: nil
            )
        } else if text.count < charactersMinNumber {
            view?.updateUIElements(
                text: Resources.Authentication.lowerLabelLengthWarningText,
                font: nil,
                labelProperty: false,
                buttonProperty: nil
            )
        } else if text.count > charactersBarrierNumber {
            view?.updateUIElements(
                text: nil,
                font: .textLabelFont,
                labelProperty: nil,
                buttonProperty: true
            )
        } else {
            view?.updateUIElements(
                text: nil,
                font: .textHeadingFont,
                labelProperty: nil,
                buttonProperty: true
            )
        }
    }

    func handleEnterButtonTap(with name: String) -> String {
        if name.isEmpty {
            view?.updateUIElements(
                text: Resources.Authentication.lowerLabelInputNameWarningText,
                font: nil,
                labelProperty: false,
                buttonProperty: nil
            )
            return ""
        } else {
            UserDefaults.standard.setValue(name, forKey: "userName")
            DispatchQueue.main.async {
                self.authFinish()
            }
            return checkUserNameProperty()
        }
    }

    func checkUserNameProperty() -> String {
        guard let savedName = UserDefaults.standard.string(forKey: "userName") else { return "" }
        return savedName
    }

}
