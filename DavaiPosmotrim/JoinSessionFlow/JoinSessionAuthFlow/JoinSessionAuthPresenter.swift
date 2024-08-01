//
//  JoinSessionAuthPresenter.swift
//  DavaiPosmotrim
//
//  Created by Эльдар Айдумов on 28.07.2024.
//

import Foundation

final class JoinSessionAuthPresenter: JoinSessionAuthPresenterProtocol {

    // MARK: - Public properties

    weak var coordinator: JoinSessionAuthCoordinator?
    weak var view: JoinSessionAuthViewProtocol?

    // MARK: - Initializers

    init(coordinator: JoinSessionAuthCoordinator) {
        self.coordinator = coordinator
    }

    // MARK: - Public methods

    func finishSessionAuth() {
        guard let coordinator else { return }
        coordinator.finish()
    }

    func showJoinSession() {
        guard let coordinator else { return }
        coordinator.showJoinSessionFlow()
    }

    func checkSessionCode(with code: String) {
        let createdCode = "AAaa567"
        UserDefaults.standard.setValue(createdCode, forKey: Resources.JoinSession.joinSessionCreatedCode)

        // TODO: - add logic to fetch createdCode from server

        if code == createdCode {
            view?.updateUIElements(
                text: nil,
                font: nil,
                labelIsHidden: true,
                buttonIsEnabled: true
            )
        } else {
            view?.updateUIElements(
                text: Resources.Authentication.lowerLabelSessionNotFound,
                font: nil,
                labelIsHidden: false,
                buttonIsEnabled: false
            )
        }
    }
}
