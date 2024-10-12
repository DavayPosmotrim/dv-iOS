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
    }

    // MARK: - Public methods

    func joinSessionFinish() {
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
                self.coordinator?.showStartSessionScreen()
            }
        }
    }

    // TODO: - rewrite "add" and "delete" methods to maintain adding/deleting names by their server id

    func addNameToArray(name: ReusableCollectionCellModel) {
        namesArray.append(name)
    }

    func deleteNameFromArray(with id: String?) {
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
