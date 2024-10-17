//
//  InvitingUsersPresenter.swift
//  DavaiPosmotrim
//
//  Created by Aleksandr Garipov on 28.05.2024.
//

import Foundation

final class InvitingUsersPresenter: InvitingUsersPresenterProtocol {

    // MARK: - Public Properties

    weak var coordinator: InvitingUsersCoordinator?
    weak var view: InvitingUsersViewProtocol?

    // MARK: - Private Properties

    private var webSocketsManager: WebSocketsManager?
    private var isCreatorUserInArray = false
    private var sessionService: SessionServiceProtocol

    private var code: String {
        guard let code = UserDefaults.standard.string(
            forKey: Resources.Authentication.sessionCode
        ) else {
            return ""
        }
        return code
    }

    private var namesArray = [ReusableCollectionCellModel]() {
        didSet {
            updateReusableCollection()
        }
    }

    // MARK: - Initializers

    init(
        coordinator: InvitingUsersCoordinator,
        sessionService: SessionServiceProtocol = SessionService()
    ) {
        self.coordinator = coordinator
        self.sessionService = sessionService
    }

    // MARK: - Public methods

    func viewDidAppear() {
        view?.showLoader()
        connectToUsersWebSocket {
            DispatchQueue.main.async {
                self.view?.hideLoader()
            }
            if !self.isCreatorUserInArray {
                self.addCreatorUserInArray()
            }
        }
    }

    func getNamesCount() -> Int {
        namesArray.count
    }

    func getNamesAtIndex(index: Int) -> ReusableCollectionCellModel {
        namesArray[index]
    }

    func getSessionCode() -> String {
        code
    }

    func startButtonTapped() {
        if namesArray.count > 1 {
            startVotingSessionStatus { isSuccess in
                self.view?.isServerReachable = isSuccess
                if isSuccess {
                    self.presentActionAfterDelay {
                        self.coordinator?.showStartSessionScreen()
                    }
                }
            }
        } else {
            view?.showFewUsersWarning()
        }
    }

    func codeButtonTapped() {
        view?.showCodeCopyWarning()
        view?.copyCodeToClipboard(code)
    }

    func inviteButtonTapped() {
        view?.shareCode(code)
    }

    func cancelButtonTapped() {
        view?.showCancelSessionDialog()
    }

    func quitSessionButtonTapped() {
        disconnectUserFromSession { [weak self] isSuccess in
            self?.view?.isServerReachable = isSuccess
            if isSuccess {
                self?.webSocketsManager?.disconnect()
                self?.coordinator?.finish()
            }
        }
    }

    // MARK: - Private methods

    private func updateReusableCollection() {
        NotificationCenter.default.post(
            name: NSNotification.Name(Resources.ReusableCollectionView.updateCollectionView),
            object: nil
        )
    }

    private func addCreatorUserInArray() {
        guard let deviceId = UserDefaults.standard.string(forKey: Resources.Authentication.savedDeviceID),
              let name = UserDefaults.standard.string(forKey: Resources.Authentication.savedNameUserDefaultsKey)
        else { return }

        let updatedName = "\(name)" + Resources.InvitingSession.creatorUserMark
        let creatorUser = ReusableCollectionCellModel(id: deviceId, title: updatedName)
        namesArray.append(creatorUser)
        isCreatorUserInArray = true
    }

    private func presentActionAfterDelay(error: @escaping () -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            error()
        }
    }
}

    // MARK: - WebSocketsManager

extension InvitingUsersPresenter {

    func connectToUsersWebSocket(
        completion: @escaping () -> Void
    ) {
        guard let sessionID = UserDefaults.standard.string(
            forKey: Resources.Authentication.sessionCode
        ) else {
            return
        }

        let messageHandler: (String) -> Void = { [weak self] message in
            guard let data = message.data(using: .utf8),
                  let self
            else {
                return
            }

            do {
                let decodedData = try JSONDecoder().decode(WebSocketsUserModel.self, from: data)
                decodeDataFromResponse(with: decodedData)
            } catch {
                DispatchQueue.main.async {
                    self.presentActionAfterDelay {
                        self.view?.showNetworkError()
                    }
                }
            }
        }

        let errorHandler: () -> Void = { [weak self] in
            guard let self else { return }
            DispatchQueue.main.async {
                self.presentActionAfterDelay {
                    self.view?.showServerError()
                }
            }
        }

        let model = WebSocketsModel(
            stringAction: messageHandler,
            dataAction: nil,
            errorAction: errorHandler
        )

        webSocketsManager = WebSocketsAPI.createWebSocketManager(for: .usersUpdate, sessionID: sessionID)
        webSocketsManager?.configureSocket(with: model)

        completion()
    }

    func decodeDataFromResponse(with model: WebSocketsUserModel) {
        guard let deviceId = UserDefaults.standard.string(
            forKey: Resources.Authentication.savedDeviceID
        ) else { return }

        var array = model.message

        let newUserIDs = Set(array.map { $0.deviceId.uppercased() })
        namesArray.removeAll { existingUser in
            !newUserIDs.contains(existingUser.id.uppercased())
        }

        array.removeAll { $0.deviceId.uppercased() == deviceId }

        for item in array {
            let newUser = ReusableCollectionCellModel(id: item.deviceId, title: item.name)
            let exists = namesArray.contains { existingUser in
                existingUser.id.uppercased() == newUser.id.uppercased()
            }
            if !exists {
                namesArray.append(newUser)
            }
        }
    }
}

    // MARK: - SessionService

extension InvitingUsersPresenter {

    func disconnectUserFromSession(completion: @escaping (Bool) -> Void) {
        guard
            let deviceId = UserDefaults.standard.string(
                forKey: Resources.Authentication.savedDeviceID),
            let sessionCode = UserDefaults.standard.string(
                forKey: Resources.Authentication.sessionCode
            )
        else { return }

        // TODO: - add loadingVC to show loader while processing request

        sessionService.disconnectUserFromSession(sessionCode: sessionCode, deviceId: deviceId) { [weak self] result in
            guard let self else { return }

            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    completion(true)
                    print(response.message)
                case .failure(let error):
                    completion(false)
                    switch error {
                    case .networkError:
                        self.presentActionAfterDelay {
                            self.view?.showNetworkError()
                        }
                    case .serverError:
                        self.presentActionAfterDelay {
                            self.view?.showServerError()
                        }
                    }
                }
            }
        }
    }

    func startVotingSessionStatus(completion: @escaping (Bool) -> Void) {
        guard
            let deviceId = UserDefaults.standard.string(
                forKey: Resources.Authentication.savedDeviceID),
            let sessionCode = UserDefaults.standard.string(
                forKey: Resources.Authentication.sessionCode
            )
        else { return }

        view?.showLoader()

        sessionService.startVotingSessionStatus(sessionCode: sessionCode, deviceId: deviceId) { result in
            DispatchQueue.main.async {
                self.view?.hideLoader()
                switch result {
                case .success(let response):
                    completion(true)
                    print(response.message)
                case .failure(let error):
                    completion(false)
                    switch error {
                    case .networkError:
                        self.presentActionAfterDelay {
                            self.view?.showNetworkError()
                        }
                    case .serverError:
                        self.presentActionAfterDelay {
                            self.view?.showServerError()
                        }
                    }
                }
            }
        }
    }
}
