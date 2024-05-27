//
//  JoinSessionPresenter.swift
//  DavaiPosmotrim
//
//  Created by Эльдар Айдумов on 23.05.2024.
//

import Foundation

final class JoinSessionPresenter: JoinSessionPresenterProtocol {

    private var namesArray = [ReusableCollectionCellModel]() {
        didSet {
            updateReusableCollection()
        }
    }

    // MARK: - Public Properties

    weak var coordinator: JoinSessionCoordinator?
    weak var view: JoinSessionViewProtocol?

    // MARK: - Initializers

    init(coordinator: JoinSessionCoordinator) {
        self.coordinator = coordinator
        downloadNamesArrayFromServer()
    }

    // MARK: - Public methods

    func authFinish() {
        guard let coordinator else { return }
        coordinator.finish()
    }

    func getNamesCount() -> Int {
        namesArray.count
    }

    func getNamesAtIndex(index: Int) -> ReusableCollectionCellModel {
        namesArray[index]
    }

    // Метод для имитации присоединения пользователей
    func downloadNamesArrayFromServer() {
        DispatchQueue.global().async {
            let downloadedNames = [
                ReusableCollectionCellModel(title: "Эльдар(вы)"),
                ReusableCollectionCellModel(title: "Юрий"),
                ReusableCollectionCellModel(title: "Сергей"),
                ReusableCollectionCellModel(title: "Александр"),
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

    // TODO: - rewrite "add" and "delete" methods to maintain adding/deleting names by their server id

    func addNameToArray(name: ReusableCollectionCellModel) {
        namesArray.append(name)
    }

    func deleteNameFromArray(with id: UUID?) {
        guard let id else { return }
        namesArray.removeAll { $0.id == id }
    }

    func checkCreatedCodeProperty() -> String {
        guard let createdCode = UserDefaults.standard.string(
            forKey: Resources.JoinSession.joinSessionCreatedCode
        ) else {
            return ""
        }
        return createdCode
    }

    // MARK: - Private methods

    private func updateReusableCollection() {
        NotificationCenter.default.post(
            name: NSNotification.Name(Resources.ReusableCollectionView.updateCollectionView),
            object: nil
        )
    }
}
