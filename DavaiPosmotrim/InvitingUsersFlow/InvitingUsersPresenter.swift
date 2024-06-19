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

    private let code = "GIGd281"

    private var namesArray = [ReusableCollectionCellModel]() {
        didSet {
            updateReusableCollection()
        }
    }

    init(coordinator: InvitingUsersCoordinator) {
        self.coordinator = coordinator
    }

    // MARK: - Public methods

    func viewDidLoad() {
        createSession()
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
        //TODO: - после подключения сети доделать проверку на количество юзеров и в зависимости от этого показывать варнинг или стартовать сеанс
        view?.showFewUsersWarning()
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

    private func createSession() {
        DispatchQueue.global().async {
            let downloadedNames = [
                ReusableCollectionCellModel(title: "Александр (вы)"),
                ReusableCollectionCellModel(title: "Юрий"),
                ReusableCollectionCellModel(title: "Сергей"),
                ReusableCollectionCellModel(title: "Эльдар"),
                ReusableCollectionCellModel(title: "Максим")
            ]

            var index = 0
            let delayInSeconds: TimeInterval = 2

            downloadedNames.enumerated().forEach() { index, name in
                DispatchQueue.global().asyncAfter(deadline: .now() + delayInSeconds * Double(index)) { [weak self] in
                    self?.namesArray.append(name)
                }
            }
        }
    }
}
