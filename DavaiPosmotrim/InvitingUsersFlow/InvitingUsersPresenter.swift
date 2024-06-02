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
                ReusableCollectionCellModel(title: "Александр(вы)"),
                ReusableCollectionCellModel(title: "Юрий"),
                ReusableCollectionCellModel(title: "Сергей"),
                ReusableCollectionCellModel(title: "Эльдар"),
                ReusableCollectionCellModel(title: "Максим")
            ]

            var index = 0
            let delayInSeconds: TimeInterval = 2

            for name in downloadedNames {
                DispatchQueue.global().asyncAfter(deadline: .now() + delayInSeconds * Double(index)) {
                    self.namesArray.append(name)
                }
                index += 1
            }
        }
    }
}
