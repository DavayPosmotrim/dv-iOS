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

    // MARK: - Private Properties

    private var sessionService: SessionServiceProtocol
    private var sessionCode: String?

    // MARK: - Initializers

    init(
        coordinator: JoinSessionAuthCoordinator,
        sessionService: SessionServiceProtocol = SessionService()
    ) {
        self.coordinator = coordinator
        self.sessionService = sessionService
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

    func saveSessionCode(code: String) {
        UserDefaults.standard.setValue(code, forKey: Resources.Authentication.sessionCode)
    }
}

    // MARK: - SessionService

extension JoinSessionAuthPresenter {

    func connectUserToSession(with sessionCode: String, completion: @escaping (Bool) -> Void) {
        guard let deviceId = UserDefaults.standard.string(
            forKey: Resources.Authentication.savedDeviceID
        ) else { return }

        view?.showLoader()
        sessionService.connectUserToSession(sessionCode: sessionCode, deviceId: deviceId) { [weak self] result in
            guard let self else { return }
            self.view?.hideLoader()

            switch result {
            case .success(let response):
                completion(true)
                print(response.users)
            case .failure(let error):
                completion(false)
                switch error {
                case .networkError:
                    view?.showNetworkError()
                case .serverError:
                    view?.showSessionCodeError()
                }
                print("Failed to connect user: \(error)")
            }
        }
    }
}
