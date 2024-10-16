//
//  JoinSessionPresenter.swift
//  DavaiPosmotrim
//
//  Created by Эльдар Айдумов on 23.05.2024.
//

import Foundation

final class JoinSessionPresenter: JoinSessionPresenterProtocol {

    // MARK: - Private Properties

    private var sessionService: SessionServiceProtocol
    private var webSocketsManager: WebSocketsManager?
    private var isConnectedUsersInArray = false
    private var namesArray = [ReusableCollectionCellModel]() {
        didSet {
            updateReusableCollection()
        }
    }

    // MARK: - Public Properties

    weak var coordinator: JoinSessionCoordinator?
    weak var view: JoinSessionViewProtocol?

    var code: String {
        guard let code = UserDefaults.standard.string(
            forKey: Resources.Authentication.sessionCode
        ) else {
            return ""
        }
        return code
    }

    // MARK: - Initializers

    init(
        coordinator: JoinSessionCoordinator,
        sessionService: SessionServiceProtocol = SessionService()
    ) {
        self.coordinator = coordinator
        self.sessionService = sessionService
    }

    // MARK: - Public methods

    func getNamesCount() -> Int {
        namesArray.count
    }

    func getNamesAtIndex(index: Int) -> ReusableCollectionCellModel {
        namesArray[index]
    }

    func connectToWebSockets() {
        connectToUsersWebSocket {
            DispatchQueue.main.async {
                self.view?.hideLoader()
            }
            if !self.isConnectedUsersInArray {
                self.decodeConnectedUsers()
            }
        }
    }

    // Метод для имитации присоединения пользователей
    func downloadNamesArrayFromServer() {
        DispatchQueue.global().async {
            let downloadedNames = [
                ReusableCollectionCellModel(id: "", title: "Эльдар(вы)"),
                ReusableCollectionCellModel(id: "", title: "Юрий"),
                ReusableCollectionCellModel(id: "", title: "Сергей"),
                ReusableCollectionCellModel(id: "", title: "Александр"),
                ReusableCollectionCellModel(id: "", title: "Максим")
            ]

            let delayInSeconds: TimeInterval = 2
            let dispatchGroup = DispatchGroup()

            downloadedNames.enumerated().forEach { index, name in
                dispatchGroup.enter()
                DispatchQueue.global().asyncAfter(deadline: .now() + delayInSeconds * Double(index)) {
                    self.namesArray.append(name)
                    dispatchGroup.leave()
                }
            }

            dispatchGroup.notify(queue: .main) {
                // TODO: - add line below to voting session status completion
//                self.coordinator?.showStartSessionScreen()
            }
        }
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

    // TODO: - handle case when user connected while network connection is lost

    private func decodeConnectedUsers() {
        guard let deviceId = UserDefaults.standard.string(
            forKey: Resources.Authentication.savedDeviceID
        ) else { return }

        let connectedUsers = getConnectedUsers()
        for item in connectedUsers {
            if item.deviceId.uppercased() == deviceId {
                let updatedName = "\(item.name)" + Resources.InvitingSession.creatorUserMark
                let updatedUser = ReusableCollectionCellModel(id: deviceId, title: updatedName)
                namesArray.append(updatedUser)
            } else {
                let newUser = ReusableCollectionCellModel(id: item.deviceId, title: item.name)
                namesArray.append(newUser)
            }
        }
        isConnectedUsersInArray = true
    }

    // MARK: - Private methods

    private func updateReusableCollection() {
        NotificationCenter.default.post(
            name: NSNotification.Name(Resources.ReusableCollectionView.updateCollectionView),
            object: nil
        )
    }

    private func presentErrorAfterDelay(error: @escaping () -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            error()
        }
    }

    private func getConnectedUsers() -> [CustomUserModel] {
        guard
            let savedData = UserDefaults.standard.data(
                forKey: Resources.Authentication.connectedUsers
            ),
            let decodedUsers = try? JSONDecoder().decode(
                [CustomUserModel].self,
                from: savedData
            )
        else { return [] }

        return decodedUsers
    }
}

    // MARK: - WebSocketsManager

extension JoinSessionPresenter {

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
                    self.presentErrorAfterDelay {
                        self.view?.showNetworkError()
                    }
                }
            }
        }

        let errorHandler: () -> Void = { [weak self] in
            guard let self else { return }
            DispatchQueue.main.async {
                self.presentErrorAfterDelay {
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

extension JoinSessionPresenter {

    func disconnectUserFromSession(completion: @escaping (Bool) -> Void) {
        guard
            let deviceId = UserDefaults.standard.string(
                forKey: Resources.Authentication.savedDeviceID),
            let sessionCode = UserDefaults.standard.string(
                forKey: Resources.Authentication.sessionCode
            )
        else { return }

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
                        self.presentErrorAfterDelay {
                            self.view?.showNetworkError()
                        }
                    case .serverError:
                        self.presentErrorAfterDelay {
                            self.view?.showServerError()
                        }
                    }
                }
            }
        }
    }
}
