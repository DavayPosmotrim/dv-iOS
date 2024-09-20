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

    private var sessionCode: String?

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

    // TODO: - add logic to fetch sessionCode from server

    func downloadSessionCode() {
        let downloadedCode = "AAaa567"
        UserDefaults.standard.setValue(downloadedCode, forKey: Resources.JoinSession.joinSessionCreatedCode)
        sessionCode = downloadedCode
    }

    func checkSessionCode(with code: String) {
        let pattern = "^[A-Za-z]{4}\\d{3}$"
        guard let regex = try? NSRegularExpression(pattern: pattern) else { return }
        let range = NSRange(location: 0, length: code.utf16.count)
        let matches = regex.matches(in: code, range: range)

        if !matches.isEmpty && code == sessionCode {
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
