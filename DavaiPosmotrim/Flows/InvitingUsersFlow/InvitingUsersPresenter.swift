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

    init(coordinator: InvitingUsersCoordinator) {
        self.coordinator = coordinator
    }

    // MARK: - Public methods

    func viewDidAppear() {
        view?.showLoader()
        connectToUsersWebSocket {
            DispatchQueue.main.async {
                self.view?.hideLoader(completion: nil)
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
            coordinator?.showStartSessionScreen()
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
        webSocketsManager?.disconnect()
    }

    func quitSessionButtonTapped() {
        coordinator?.finish()
        //TODO: - настроить отмену сессии, когда подключим сеть
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
                    self.view?.hideLoader {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            self.view?.showNetworkError()
                        }
                    }
                }
            }
        }

        let errorHandler: () -> Void = {
            DispatchQueue.main.async {
                self.view?.hideLoader {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        self.view?.showServerError()
                    }
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
